# encoding: utf-8

require 'digest/md5'
require 'net/http'

class Missings::NewController < Missings::ApplicationController
  
  def index
    session[:missing_id] ||= 0              

    if session[:missing_id] == 0
      create_new_missing
    else
      @missing = Missing.find(session[:missing_id])
    end

    # Поля для фоток
    @missing.photos.build

    @questions = Question.for(@missing, current_or_guest_user, :all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @missing }
    end
  end


  # Сохраняем данные текущего шага
  def update
    session[:missing_id] ||= 0
    params[:missing] ||= {}
    data_type = data = ""
       
    # Костыль
    # Если, не указан день рождения, ставим 1 января
    params[:missing]["birthday(3i)"] = params[:missing]["birthday(2i)"] = "1" if params[:missing]["birthday(3i)"] == "" or params[:missing]["birthday(2i)"] == ""

    # Если объявление уже создано, сохраняем в базу изменения
    # или создаем в базе
    if session[:missing_id] > 0
      @missing = Missing.find(session[:missing_id])

      # TODO: разобраться, что это за костыль
      if params[:missing]["user_attributes"] && params[:missing]["user_attributes"]["email"].empty?
        params[:missing]["user_attributes"].delete("email")
      end

      @missing.update_attributes(params[:missing]) 
      
      @missing.save
    else
      # TODO: разобраться, что это за костыль
      params[:missing].delete("user_attributes")

      @missing = create_new_missing
    end         
    
    # Передаём фотки, чтобы обновить на странице
    data_type = "photos"
    data = []
    @missing.photos.each do |p|
      data.push({ :id => p.id, :image_name => p.photo.url(:small) })
    end
                   
    respond_to do |format|
      format.json {
        render :json => { :ok => "true", :missing_url => url_for(@missing), :data_type => data_type, :data => data } 
      }
    end
  end 

  def create
      return if !Missing.exists?(session[:missing_id]) 
      @missing = Missing.find(session[:missing_id])

      # Не отсылаем письмо с просьбой подтвердить почту
      @missing.user.confirmed_at = DateTime.now
      @missing.user.save

      @missing.published = true  
      @missing.save  
      
      # TODO: убрать костыли, сделать очередь писем
      begin
        password = params[:missing]["user_attributes"] ? params[:missing]["user_attributes"]["password"] : ""
        UserMailer.new_missing_email(@missing, password).deliver
      rescue
        logger.debug("Can't send mail")
      end

      # Убираем следы
      session[:missing_id] = nil
      
      # Логинимся
      sign_in @missing.user
      
      # Даём знать странице объявлени, что она только что создалась
      flash[:hidden] = "new" 

      respond_to do |format|
        format.json {
          render :json => { :ok => "true", :missing_url => url_for(@missing) } 
        }
      end   
  end
  
  # Ищем похожие пропажи по имени и возрасту
  def search_for_similar      
    search = Search.new({ 
      :keywords => params["name"], 
      :minimum_age => params["age"].to_i - 2,
      :maximum_age => params["age"].to_i + 2,
      :male => params["gender"] })  
    
    missings = []  
    search.missings.each do |missing|
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

  # Создание новой пропажи и запись айди в сессиию
  def create_new_missing
    @missing = Missing.new

    @missing.user = current_or_guest_user
    # Если пользователь залогинен, создаём для него автора
    # TODO: сделать, чтобы устанавливался предыдущий автор
    @missing.author = Author.new({ :name => current_user.name, :phone => current_user.phone }) if current_user
    
    @missing.published = false
    @missing.valid? # Какой-то танец с бубном
    @missing.save

    session[:missing_id] = @missing.id

    @missing
  end
end
