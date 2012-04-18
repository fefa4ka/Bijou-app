# encoding: utf-8

require 'digest/md5'
require 'net/http'

class Missings::MissingsController < Missings::ApplicationController

  def index                          
      params[:search] ||= {}  
      @search = Search.new(params[:search])        
      @missings = @search.missings                                      
      @request = request

      render 'missings/search/index'
  end

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
  end

  def print
    @missing = Missing.find(params[:id])
    
    respond_to do |format|
      format.html { render :layout => false }
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
end
