class MissingsController < ApplicationController
  # GET /missings
  # GET /missings.xml
  def index
    @missings = Missing.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @missings }
    end
  end

  # GET /missings/1
  # GET /missings/1.xml
  def show
    @missing = Missing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @missing }
    end
  end

  # GET /missings/new
  # GET /missings/new.xml
  def new
    session[:missing_params] ||= {}
    @missing = Missing.new
    
    respond_to do |format|
      format.html { @missing.current_step = session[:missing_step] }# new.html.erb
      format.xml  { render :xml => @missing }
    end
  end

  # GET /missings/1/edit
  def edit
    @missing = Missing.find(params[:id])
  end

  # POST /missings
  # POST /missings.xml
  def create
    session[:missing_params].deep_merge!(params[:missing]) if params[:missing]
    @missing = Missing.new(session[:missing_params])
    @missing.current_step = session[:missing_step]
    
    if params[:back_button]
      @missing.previous_step
    elsif @missing.last_step?
      @missing.save
    else
      @missing.next_step
    end
    session[:missing_step] = @missing.current_step
    
    if @missing.new_record?
      render "new"
    else
      session[:missing_params] = session[:missing_step] = nil
      flash[:notice] = "Объявление размещено"
      redirect_to @missing  
    end
  end

  # PUT /missings/1
  # PUT /missings/1.xml
  def update
    @missing = Missing.find(params[:id])

    respond_to do |format|
      if @missing.update_attributes(params[:missing])
        format.html { redirect_to(@missing, :notice => 'Missing was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @missing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /missings/1
  # DELETE /missings/1.xml
  def destroy
    @missing = Missing.find(params[:id])
    @missing.destroy

    respond_to do |format|
      format.html { redirect_to(missings_url) }
      format.xml  { head :ok }
    end
  end
end
