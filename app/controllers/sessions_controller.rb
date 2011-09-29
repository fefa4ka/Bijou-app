class SessionsController < ApplicationController
  def create
    user = login(params[:email], params[:password], params[:remember_me]) 
    
    if user                                            
      if user.missings.length > 0
        url = missing_path(user.missings.first)
      else
        url = root_url
      end             
      
      redirect_back_or_to url
    else
      flash.now.alert = "Email or password was invalid"
      render :new
    end     
  end
  
  def destroy
    logout
    redirect_to root_url
  end 
end
