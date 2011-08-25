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
  def add        
    logger.debug("SESSION: #{session.inspect}")
    
    @missing = Missing.new(session[:missing_params])
    @missing.valid?
    @places = @missing.places.to_gmaps4rails
    
    @missing.current_step = params[:step]

    # Поля для мест и людей
    # Строятся только один раз
    if @missing.current_step == "common"
      photo = @missing.photos.build
      
      session[:missing_in_progress_common] = true
    elsif @missing.current_step == "history"  
      place = @missing.places.build
      familiar = @missing.familiars.build
      
      session[:missing_in_progress_history] = true
    end
    
    
    if @missing.new_record?
      render "new"
    else
      
      flash[:notice] = "Объявление размещено"
      redirect_to @missing  
    end
  end

  # Сохраняем данные текущего шага
  def save_step
    logger.debug("SESSION: #{session.inspect}")
    session[:missing_params] ||= {}
    session[:missing_params].deep_merge!(params[:missing]) if params[:missing]
    
    
    respond_to do |format|
      if params[:save]
        @missing = Missing.new(session[:missing_params])
        @missing.save
        
        session[:missing_params] = session[:missing_in_progress] = nil
        flash[:notice] = "Объявление размещено"
      end
      
      format.json {
        render :json => { :success => "true", :missing_url => url_for(@missing) } 
      }
    end
  end 
  
  # Обработка посещаяемых мест
  def address_suggest
    if params[:term]
      georesult = Gmaps4rails.geocode("москва" + params[:term], "ru&region=ru")
      suggest = Array.new
      georesult.each do |address|
        suggest.push(address[:matched_address])
      end
    end
    
    respond_to do |format|
      format.json { 
        render :json => suggest || {}
      }
    end
  end
  
  # Получение данных по адресу
  def address_data
    if params[:address]
      georesult = Gmaps4rails.geocode(params[:address], "ru")
      
      respond_to do |format|
        format.json {
          render :json => georesult.first
        }
      end
    # else
    #   places_session = session[:missing_params]["places_attributes"]
    #   places = []
    #   places_session.each do |place|
    #     p = Place.new({ :address => place["address"] })
    #     logger.debug(p.inspect)
    #     places.push(p)
    #   end
    #   respond_to do |format|
    #     format.json {
    #       render :json => places.to_gmaps4rails
    #     }
    #   end
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
