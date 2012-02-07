# encoding: utf-8

require 'digest/md5'
require 'net/http'

class MissingsController < ApplicationController
  # Каталог для фоток
   impressionist :actions => [:show]           
  
  # GET /missings
  # GET /missings.xml
  def index                          
      params[:search] ||= {}
      @search = Search.new(params[:search])
      @missings = @search.missings
      @request = request
  end

  # GET /missings/1
  # GET /missings/1.xml
  def show               
  	@missing = Missing.find(params[:id])                  
    @author = User.find(@missing.user_id)

	  @discussion = Discussion.new({ :missing_id => @missing.id })
	  @message = Message.new 

      @location = get_user_location 
      @seen = SeenTheMissing.where( { :missing_id => @missing.id, :user_id => current_or_guest_user } ).first
      @seen = SeenTheMissing.new( { :missing_id => @missing.id, :address => @location.nil? ? "" : @location }) if @seen.nil?

	  @helpers = []

	  # Вопросы 
	  @questions = Question.for @missing, current_or_guest_user, :all   
    
	    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @missing }
    end
  end

  def print
    @missing = Missing.find(params[:id])
    
    respond_to do |format|
      format.html { render :layout => false }
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
  	
  # GET /missings/new
  # GET /missings/new.xml
  def new                
    session[:missing_id] ||= 0              

    @missing = session[:missing_id] > 0 ? Missing.find(session[:missing_id]) : Missing.new
    @missing.user = current_or_guest_user if @missing.new_record?

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

      if params[:missing]["user_attributes"] && params[:missing]["user_attributes"]["email"].empty?
        params[:missing]["user_attributes"].delete("email")
      end

    	@missing.update_attributes(params[:missing])    
    	@missing.save
    else
        params[:missing].delete("user_attributes")

        @missing = Missing.new(params[:missing])
        @missing.user = current_or_guest_user
    	@missing.published = false;
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

        UserMailer.new_missing_email(@missing, params[:missing]["user_attributes"]["password"]).deliver

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


  def i_seen_the_missing
    seen_params = params[:seen_the_missing]
    seen = SeenTheMissing.where({ :missing_id => seen_params[:missing_id], :user_id => current_or_guest_user })
    
    if seen.size == 0
      seen = SeenTheMissing.new seen_params
      seen.user = current_or_guest_user
    else
      seen = seen.first
      seen.update_attributes seen_params
    end

    if seen.save
      respond_to do |format|
        format.json { 
          render :json => { :ok => true } 
        }
      end
    end
  end

  private
   def get_user_location
    logger.debug("get location #{request.location.inspect}");
    if session[:location]
      location = session[:location]
    else
      location = request.location
      unless request.location.nil?
        location = Geocoder.search("#{location.latitude},#{location.longitude}").first
        session[:location] = location.city
      end
    end

    return location
    
  end
end
