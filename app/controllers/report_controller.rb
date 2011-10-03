# encoding: utf-8

class ReportController < ApplicationController                        
  def index
    @inbox = Message.where("destination_user_id = ?", current_user.id)         
    @message = Message.new({ :user_id => current_user.id })        
    if current_user.missings.length > 0 
      @missing = current_user.missings.first
    end  
    
    if current_user.role == 1
      render 'detective'
      return
    end
  end
  
    
end
