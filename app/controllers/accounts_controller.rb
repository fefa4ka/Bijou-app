# encoding: utf-8

class AccountsController < ApplicationController        
  def send_message
     @message = Message.new(params[:message])       
     @message.save           
     
     respond_to do |format| 
       format.json {
         render :json => { :ok => "true" } 
       }           
     end
  end
end
