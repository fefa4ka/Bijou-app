# encoding: utf-8

class UsersController < ApplicationController
  def new          
    @user = User.new
  end
               
  def create               
    @user = User.new(params[:user])
    
    if @user.save    
      redirect_to root_url
    else
      render :new
    end
  end

  
  def send_message                        
     params[:message]["user_id"] = (current_user && current_user.id) || nil
     @message = Message.new(params[:message]) 
     @message.convert_from_answer      
     @message.save           
    
     if @message.user.nil?
        user = { :id => 0, :username => params[:message]["name"] } 
     else
        user = { :id => @message.user.id, :username => @message.user.name }
     end

     data = {
       :text => @message.text,    
       :message_id => @message.message_id,
       :date => Russian.strftime(@message.created_at, "%d %B"), 
       :user => user 
     }                                                         


     respond_to do |format| 
       format.json {
         render :json => { :ok => "true", :message => data } 
       }           
     end
  end   
  
  private 
    def convert_to_hash
    	data = params[:user]
    	specialization = {
    		:specialization_1 => data["specialization_1"],
    		:specialization_2 => data["specialization_2"],
    		:specialization_3 => data["specialization_3"],
    		:specialization_additional => data["specialization_additional"]
    	}                                                                

    	callback_hash = data["callback_phone"].to_s + data["callback_email"].to_s

    	params[:user]["specialization"] = specialization
    	params[:user]["callback"] = callback_hash
    end
end
