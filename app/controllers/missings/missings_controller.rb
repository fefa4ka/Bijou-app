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
    @missing = Missing.find(params[:missing_id])
    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
                      
  def questions
    @missing = Missing.find(params[:missing_id])
    @questions = Question.for @missing, current_or_guest_user, :all  
    
    respond_to do |format|
      format.json { 
        render :json => @questions
      }
    end
  end 
end
