# encoding: utf-8

class ReportController < ApplicationController   
  impressionist :action => [:index, :inbox]
                       
  def report  
    if current_user.detective?
      detective_report  
      return
    end
    
    @inbox = Message.where("destination_user_id = ?", current_user.id)         
    @message = Message.new({ :user_id => current_user.id })        
    if current_user.missings.length > 0 
      @missing = current_user.missings.first
    end  
  end      
  
  def detective_report 
    @missings = Missing.all
    render 'detective'
  end

  
  def inbox
    @inbox = Message.where("destination_user_id = ?", current_user.id)         
    @message = Message.new({ :user_id => current_user.id })            
    if current_user.missings.length > 0 
      @missing = current_user.missings.first
    end                           
    
    @contacts = User.all
  end  
end
