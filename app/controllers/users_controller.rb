# encoding: utf-8

class UsersController < ApplicationController
  def new          
    @user = User.new
  end
               
  def create               
    convert_to_hash       
    params[:user]["role"] = 1
    
    @user = User.new(params[:user])
    
    if @user.save    
      login @user.username, params[:user]["password"], true
      redirect_to root_url
    else
      render :new
    end
  end

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
  
  def send_message                        
     params[:message]["user_id"] = current_user.id
     @message = Message.new(params[:message]) 
     @message.convert_from_answer      
     @message.save           
     
     if @message.user.nil?
       @message.user = { :id => 0, :username => "Анонимный комментарий" }          
     end


     data = {
       :text => @message.text,    
       :message_id => @message.message_id,
       :date => Russian.strftime(@message.created_at, "%d %B"), 
       :user => {
         :id => @message.user.id,
         :username => @message.user.username
       }
     }                                                         


     respond_to do |format| 
       format.json {
         render :json => { :ok => "true", :message => data } 
       }           
     end
  end
end
