class UsersController < ApplicationController
  before_filter :for_current_user,
    :only => [:edit, :update]

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

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end   
  
  def check_email                    
    @user = User.where(:email => params[:email]).first 
    logger.debug(@user)
    respond_to do |format|
      format.json { 
        render :json => !@user 
      }
     end
   end
  
  # POST /users
  # POST /users.json
  def create                    
    @user = User.where(:email => params[:user][:email]) || User.new(params[:user])

    respond_to do |format|
      if @user.new_record?
        @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def for_current_user
    unless current_user and !(params[:id] == current_user.id)
      respond_to do |format|
        format.html { 
          head :forbidden 
        }
      end
    end
  end


end
