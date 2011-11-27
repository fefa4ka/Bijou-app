# encoding: utf-8

require 'digest/md5'
require 'net/http'

class MissingsController < ApplicationController
  # Каталог для фоток
  PHOTO_STORE = File.join Rails.root, 'public', 'photos'
  
  impressionist :actions => [:show]           
  
  # GET /missings
  # GET /missings.xml
  def index                          
    if defined? current_user.missings.first   
      redirect_to missing_path(current_user.missings.first)
    else
      redirect_to root_url
    end      
  end

  # GET /missings/1
  # GET /missings/1.xml
  def show                                             
    
  	@missing = Missing.find(params[:id])                  
  	
    @places = @missing.places.to_gmaps4rails
    @author = User.find(@missing.user_id)             

	  @discussion = Discussion.new({ :missing_id => @missing.id })        
	  @message = Message.new({ :user_id => @missing.user_id }) 
	  
	  @helpers = @missing.can_helps                   
	  
	  # Данные, о чем может помочь посетитель   
	  @help_types = HelpType.all
	  
	  if user_signed_in?
      @i_can_help = CanHelp.where(:user_id => current_user.id, :missing_id => params[:id]).first || CanHelp.new
	  else
	    @i_can_help = CanHelp.new
    end        
	  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @missing }
    end
  end
                      
  # Add comment
  def add_comment                                             
    params[:discussion]["user_id"] = current_user.id
    
    @missing = Missing.find(params[:discussion]["missing_id"])
    @comment = Discussion.new(params[:discussion])       
    @comment.save           
    
    if @comment.user.nil?
      @comment.user = {
        :id => 0,
        :username => "Анонимный комментарий" 
      }          
    end
    
    
    data = {
      :comment => @comment.comment,    
      :discussion_id => @comment.discussion_id,
      :date => Russian.strftime(@comment.created_at, "%d %B"), 
      :user => {
        :id => @comment.user.id,
        :username => @comment.user.name
      }
    }                                                         

    
    respond_to do |format| 
      format.json {
        render :json => { :ok => "true", :comment => data } 
      }           
    end
  end
  
  # I can help method
  def i_can_help
  	unless user_signed_in?
	  	render :nothing => true   
	  	return
	  end
	          
	  data = {
  		:missing => Missing.find(params[:missing_id]),
  		:user_id => current_user.id
	  }
	               
    i_can_help = CanHelp.where(:user_id => current_user.id, :missing_id => params[:missing_id]).first || CanHelp.new
    i_can_help.update_attributes(params[:can_help])
    
 	  i_can_help.save
 	
 	  respond_to do |format|
   		format.json {
   			render :json => { :ok => "true" }
  		}
  	end
  end

  	
  # GET /missings/new
  # GET /missings/new.xml
  def new                  
          
    session[:missing_params] ||= {}                  

    logger.debug(session[:missing_params].inspect)
    @missing = Missing.new(session[:missing_params])
    @missing.valid?
    @places = @missing.places.to_gmaps4rails
    
    @missing.current_step = params[:step]
  	
    # Поля для мест и людей
    # Строятся только один раз
    if @missing.new_record?
      	@missing.places.build
      	@missing.photos.build
      	@missing.familiars.build

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @missing }
	  end
    else
      flash[:notice] = "Объявление размещено"
      redirect_to @missing  
    end
  end

  # GET /missings/1/edit
  def edit
    @missing = Missing.find(params[:id])
  end

  # Сохраняем данные текущего шага
  def save_step
    session[:missing_params] ||= {}  
    session[:missing_photos] ||= []
    session[:missing] ||= {}
    params[:missing] ||= {}
     
    logger.debug(session.inspect)
  	# Сохраняем фотографии
  	data_type = data = ""
  	photos = params[:missing]["photos_attributes"] || {}
  	if photos.count > 0
      params[:missing]["photos_attributes"] = upload_photos photos 
  	  data = params[:missing]["photos_attributes"]
  	  data_type = "photos"
  	end

    session[:missing_params].merge!(params[:missing]) if params[:missing]
        
    logger.debug('before respond')                    
    
    respond_to do |format|
      logger.debug(params[:save])
      if params[:save] == "1"
        logger.debug(session[:missing_params].inspect)
      	convert_to_hash
        
        @missing = Missing.new(session[:missing_params])
        @missing.photos = session[:missing_photos]     
        @missing.save  
    	#         if logged_in? 
    	# 	current_user.push(@missing)
    	# 	
    	# else
    		user = {
	      		:name => session[:missing_params]["author_name"],
	      		:email => session[:missing_params]["author_email"],
	      		:phone => session[:missing_params]["author_phone"],
	      		:callback => session[:missing_params]["author_callback_hash"],
	      		:password => session[:missing_params]["missing_password"]
	  	  }                    

	      @user = User.new(user)
  		  @user.missings.push(@missing)  
        @user.save    
         
        
        session[:missing_params] = session[:missing_photos] = nil
        
        sign_in @user
		    # end
        flash[:notice] = "Объявление размещено"
      end
             
      
      format.json {
        render :json => { :ok => "true", :missing_url => url_for(@missing), :data_type => data_type, :data => data } 
      }
    end
  end 
  
  def convert_to_hash
  	data = session[:missing_params]
  	characteristics = {
  		:man_growth => data["man_growth"],
  		:man_physique => data["man_physique"],
  		:man_physique_another => data["man_physique_another"],
  		:man_hair_length => data["man_hair_length"],
  		:man_hair_color => data["man_hair_color"],
  		:man_hair_color_another => data["man_hair_color_another"],
  		:man_specials_tattoo => data["man_specials_tattoo"],
  		:man_specials_piercing => data["man_specials_piercing"],
  		:man_specials_scar => data["man_specials_scar"],
  		:man_specials => data["man_specials"]
  	}
  	callback_hash = data["author_callback_phone"].to_s + data["author_callback_email"].to_s
  	private_hash = data["private_history"].to_s + data["private_contacts"].to_s
  	
  	session[:missing_params]["characteristics"] = characteristics
  	session[:missing_params]["author_callback_hash"] = callback_hash
  	session[:missing_params]["private"] = private_hash
  end
  	
  def upload_photos(photos)
  	# Сохраняем фотку
  	# как результат возвращаем массив из имен файлов
  	photos_params = {}
  	  	
  	photos.each do |id, photo|
      # file = photo[:load_photo_file]
  		
      # unless file
      unless photo[:photo] 
  		  photos_params[id] = photo
  		  next
  		end
  		
      # # Генерируется уникальное имя
      # filename = Digest::MD5.hexdigest(Time.now.to_s + file.original_filename) + File.extname(file.original_filename)
      # name = File.join PHOTO_STORE, filename
      #     
      # result.push(filename)
      # # Сохраняем файл
      # File.open(name, 'wb') do |f|
      #   f.write(file.read)
      # end   
      
      new_photo = Photo.new(photo)               
      new_photo.save
      photos_params[id] = { :image_name => new_photo.photo.url(:thumb) }
      logger.debug("====FOTO")
      logger.debug(new_photo.inspect)
      session[:missing_photos].push(new_photo)
  	end
  	
    # Убираем из параметров загруженный файл. Он не сохранится в сессии
  	# Вместо этого добавляем названия сохраненных файлов    	
  	logger.debug('AVAILABLE PHOTOS')
  	logger.debug(photos_params.inspect)
    photos_params
  end
  
  # Обработка посещаяемых мест
  def address_suggest
    if params[:part]
	  address = URI.escape(params[:part])
	  ll = URI.escape(params[:ll])
	  spn = URI.escape(params[:spn])
	  callback = params[:callback]
	  rand = params[:_]
	  url = "http://suggest-maps.yandex.ru/suggest-geo?callback=#{callback}&_=#{rand}&ll=#{ll}&spn=#{spn}&part=#{address}&highlight=1&fullpath=1&sep=0&n=4&search_type=tp"
	  url = URI.parse(url)
	  suggest = Net::HTTP.get(url)
    end
    
    respond_to do |format|
      format.json { 
        render :json => suggest || {}
      }
    end
  end
  
  # Получение данных по адресу
  def address_data
    if params[:address]
      georesult = Geocoder.search(params[:address]).first
      respond_to do |format|
        format.json {
          render :json => {
            :lat => georesult.latitude,
            :lng => georesult.longitude,           
            :address => georesult.address
          }
        }
      end
    # else
    #   places_session = session[:missing_params]["places_attributes"]
    #   places = []
    #   places_session.each do |place|
    #     p = Place.new({ :address => place["address"] })
    #     logger.debug(p.inspect)
    #     places.push(p)
    #   end
    #   respond_to do |format|
    #     format.json {
    #       render :json => places.to_gmaps4rails
    #     }
    #   end
    end
    
  end
  
  # PUT /missings/1
  # PUT /missings/1.xml
  def update
    @missing = Missing.find(params[:id])

    respond_to do |format|
      if @missing.update_attributes(params[:missing])
        format.html { redirect_to(@missing, :notice => 'Missing was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @missing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /missings/1
  # DELETE /missings/1.xml
  def destroy
    @missing = Missing.find(params[:id])
    @missing.destroy

    respond_to do |format|
      format.html { redirect_to(missings_url) }
      format.xml  { head :ok }
    end
  end
end
