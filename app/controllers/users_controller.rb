class UsersController < ApplicationController

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = current_user
  end   

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(current_user)
    validation = (@user.valid_password?(params[:user][:old_password]) && params[:user][:password]) || (@user.encrypted_password.empty? && params[:user][:password])
    params[:user].delete("password") unless (@user.valid_password?(params[:user][:old_password]) && params[:user][:password]) || (@user.encrypted_password.empty? && params[:user][:password])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        sign_in @user, :bypass => true
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
    
  def check_email                    
    @user = User.where(:email => params[:email]).first 
    respond_to do |format|

      format.json {
        # При размещении объявления, пользователь создается в базе сразу, а на финальном шаге идет проверка на зарегистрированность в базе.
        render :json => !(@user && !(current_or_guest_user && current_or_guest_user.id == @user.id)) 
      }
     end
   end

end
