class ServiceController < ApplicationController
  # Саджест адреса по положению карты
  def suggest_address
    if params[:part]
	    address = URI.escape(params[:part])
	    ll = URI.escape(params[:ll])
	    spn = URI.escape(params[:spn])
	    callback = params[:callback]
	    rand = params[:_]
	    url = "http://suggest-maps.yandex.ru/suggest-geo?callback=#{callback}&_=#{rand}&ll=#{ll}&spn=#{spn}&part=#{address}&highlight=1&fullpath=1&sep=0&n=4&search_type=tp"
	    url = URI.parse(url)
	    suggest = Net::HTTP.get(url)
    end
    
    respond_to do |format|
      format.json { 
        render :json => suggest || {}
      }
    end
  end

  def check_email_exist                  
    @user = User.where(:email => params[:email]).first 
    respond_to do |format|

      format.json {
        # При размещении объявления, пользователь создается в базе сразу, а на финальном шаге идет проверка на зарегистрированность в базе.
        render :json => !(@user && !(current_or_guest_user && current_or_guest_user.id == @user.id)) 
      }
     end
   end
end
