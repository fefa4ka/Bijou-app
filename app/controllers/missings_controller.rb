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
    @author = User.find(@missing.user_id)

	@discussion = Discussion.new({ :missing_id => @missing.id })
	@message = Message.new({ :user_id => @missing.user_id }) 
	  
	@helpers = []

	  # Вопросы 
	  @questions = Question.for @missing, current_or_guest_user, :all   
	  
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
    session[:missing_id] ||= 0              

    @missing = session[:missing_id] > 0 ? Missing.find(session[:missing_id]) : Missing.new
    @missing.valid?
    
    @missing.current_step = params[:step]
  	
    # Поля для мест и людей
    # Строятся только один раз
    @missing.photos.build
      
    @questions = Question.for(@missing, current_or_guest_user, :all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @missing }
	  end
  end

  # GET /missings/1/edit
  def edit
    @missing = Missing.find(params[:id])
  end

  # Сохраняем данные текущего шага
  def save_step 
  	session[:missing_id] ||= 0
    params[:missing] ||= {}
  	data_type = data = ""
       
    # Если объявление уже создано, сохраняем в базу изменения
    # или создаем в базе копию          
    if session[:missing_id] > 0
    	@missing = Missing.find(session[:missing_id])
    	@missing.update_attributes(params[:missing])    
    	@missing.save
    else
		  @user = current_or_guest_user

    	@missing = Missing.new(params[:missing])
    	@missing.published = false;
    	@missing.user = @user
    	@missing.save
    	
    	session[:missing_id] = @missing.id
	  end         
	  
	  if params["missing_upload_photo"]     
	    data_type = "photos"
	    data = []
	    @missing.photos.each do |p|
	      data.push({ :id => p.id, :image_name => p.photo.url(:small) })
      end
	  end                  
	
    respond_to do |format|

      if params[:save] == "1"
        
        @missing = Missing.find(session[:missing_id])
        @missing.published = true  
        @missing.save  

        session[:missing_id] = nil
        
        sign_in @missing.user

        flash[:hidden] = "new"
      end
             
      
      format.json {
        render :json => { :ok => "true", :missing_url => url_for(@missing), :data_type => data_type, :data => data } 
      }
    end
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
  
  def answer_the_question
    question_params = params["question"]
    missing = Missing.find(session[:missing_id])
    user = current_or_guest_user
    
    next_question = Question.answer question_params, missing, user
    
    respond_to do |format|
      format.json {
        render :json => {
          :ok => true,
          :question => next_question
        }
      } 
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
