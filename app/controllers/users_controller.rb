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
     params[:message]["user_id"] = current_user.id
     @message = Message.new(params[:message])       
     @message.save           
     
     respond_to do |format| 
       format.json {
         render :json => { :ok => "true" } 
       }           
     end
  end
end
