# encoding: utf-8

require 'digest/md5'
require 'net/http'

class MissingsController < ApplicationController
  # Каталог для фоток
   impressionist :actions => [:show]           
  
  # GET /missings
  # GET /missings.xml
  def index                          
      params[:search] ||= { :region => get_user_location }  
      @search = Search.new(params[:search])        
      @missings = @search.missings
      @request = request
  end

  # GET /missings/1
  # GET /missings/1.xml
  def show               
  	@missing = Missing.find(params[:id])                  
    @author = @missing.author || @missing.user

    @discussion = Discussion.new({ :missing_id => @missing.id })
    @message = Message.new 

    @location = get_user_location 
    @seen = SeenTheMissing.where( { :missing_id => @missing.id, :user_id => current_or_guest_user } ).first || SeenTheMissing.new( { :missing_id => @missing.id, :address => @location.nil? ? "" : @location })

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
    @missing.author = Author.new({ :name => current_user.name, :phone => current_user.phone }) if @missing.new_record? && current_user
    @missing.published = false;
    @missing.valid?
    @missing.save
    session[:missing_id] = @missing.id

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
       
    # Костыль
    # Если, не указан день рождения, ставим 1 января
    params[:missing]["birthday(3i)"] = params[:missing]["birthday(2i)"] = "1" if params[:missing]["birthday(3i)"] == "" or params[:missing]["birthday(2i)"] == ""

    # Если объявление уже создано, сохраняем в базу изменения
    # или создаем в базе копию          
    if session[:missing_id] > 0
    	@missing = Missing.find(session[:missing_id])

      if params[:missing]["user_attributes"] && params[:missing]["user_attributes"]["email"].empty?
        params[:missing]["user_attributes"].delete("email")
      end

    	@missing.update_attributes(params[:missing]) 
      logger.debug("!!! Save #{@missing.inspect}")   
    	@missing.save
    else
      params[:missing].delete("user_attributes")

      @missing = Missing.new(params[:missing])
      @missing.user = current_or_guest_user
    	@missing.published = false;
    	@missing.save
    	
    	session[:missing_id] = @missing.id
    end         
	  
    logger.debug(params[:missing]["photo_attributes"])
   # if (params[:missing]["photo_attributes"].find_all {|r| r["photo"] }).size > 0
      data_type = "photos"
      data = []
      @missing.photos.each do |p|
        data.push({ :id => p.id, :image_name => p.photo.url(:small) })
      end
  #  end                  
	
    respond_to do |format|
      if params[:save] == "1"
        @missing = Missing.find(session[:missing_id])
        @missing.published = true  
        @missing.save  
        
        password = params[:missing]["user_attributes"] ? params[:missing]["user_attributes"]["password"] : ""
        UserMailer.new_missing_email(@missing, password).deliver

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
  
  def questions
    @missing = Missing.find(params[:id])
    @questions = Question.for @missing, current_or_guest_user, :all  
    
    respond_to do |format|
      format.json { 
        render :json => @questions
      }
    end
  end 

  def answer_the_question
    question_params = params["question"]
    missing = Missing.find(params[:id])
    user = current_or_guest_user
    
    answers = Question.answer question_params, missing, user
    # Логиним, если вопрос "Как с вами связаться?"
    if answers.size == 1 && answers.first.question.answer_type == 7
      user = User.find(answers.first.text)
      sign_in user
    end
    next_question = Question.for(missing, user, 3).first
    logger.debug(next_question)
    
    respond_to do |format|
      format.json {
        render :json => {
          :ok => true,
          :logged_in => user_signed_in?,
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
  
  def search_for_similar      
    @search = Search.new({ 
      :keywords => params["name"], 
      :minimum_age => params["age"].to_i - 1,
      :maximum_age => params["age"].to_i + 1,
      :male => params["gender"] })  
    
    missings = []  
    @search.missings.each do |missing|
      item = { 
        :name => missing.name,
        :age => missing.age,
        :photo => (missing.photos && missing.photos.first && missing.photos.first.photo.url(:small)) || "",
        :url => missing_path(missing)
      }
      missings.push(item)
    end               
    
    respond_to do |format|
      format.json {
        render :json => missings
      }      
    end
  end
  
  private
   def get_user_location
    logger.debug("get location #{request.location.inspect}");
    unless session[:location]
      location = request.location
      unless request.location.nil?
        logger.debug(location.inspect)
        location = Geocoder.search("#{location.latitude},#{location.longitude}").first
        begin
          session[:location] = location.city
        rescue Exception => e
          session[:location] = location.country
        end
      end
    end

    return session[:location]
    
  end
end
