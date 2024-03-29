class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController 
  protect_from_forgery :except => [ :facebook, :google, :vkontakte, :twitter, :yandex, :mailru ]
  
  def facebook
    @user = find_for_facebook_oauth(request.env["omniauth.auth"])

#    sign_in_and_redirect @user, :event => :authentication
    sign_in_and_close_popup @user
  end

  def google                                        
    @user = find_for_open_id(request.env["omniauth.auth"])
    
    sign_in_and_close_popup @user
  end                                    
  
  def vkontakte   
    @user = find_for_vkontakte(request.env["omniauth.auth"])  
    
    sign_in_and_close_popup @user
  end               
  
  def twitter  
    @user = find_for_twitter(request.env["omniauth.auth"])  
    
    sign_in_and_close_popup @user
  end       
  
  def yandex
    @user = find_for_yandex(request.env["omniauth.auth"])  
    
    sign_in_and_close_popup @user
  end   
  
  def mailru
     @user = find_for_mailru(request.env["omniauth.auth"])  

     sign_in_and_close_popup @user
  end

  private
    
  def find_for_facebook_oauth(access_token)
    data = access_token.extra.raw_info
    find_or_create(data.email, data.name, :facebook)
  end

  def find_for_open_id(access_token)
    data = access_token.info
    find_or_create(data["email"], data["name"])
  end         
  
  def find_for_vkontakte(access_token)
    data = access_token.extra.raw_info                  
    find_or_create("#{data['uid']}@vk.com", [data["first_name"], data["last_name"]].join(" "), :vkontakte, data["photo_big"])
  end  
  
  def find_for_twitter(access_token)
    data = access_token
    logger.debug(data)
  end   
  
  def find_for_yandex(access_token)
    data = access_token.info          
    find_or_create("#{data.nickname}@yandex.ru", data.name, :yandex, data.image)
  end  
  
  def find_for_mailru(access_token)
    data = access_token.info
    find_or_create(data["email"], data["name"], :mailru, data.image)
  end

  def find_or_create(email, name="", provider="", photo="")     
    if user = User.where(:email => email).first
      user
    else
      user = User.create!(:email => email, :name => name)
    end                        
    user.avatar_from_url(photo) unless photo == "" or photo.nil?
    user.provider = provider

    user.skip_confirmation! 
    user.save
    user
  end

  def sign_in_and_close_popup(user)
    logger.debug(user)
    sign_in user
    render :inline => "<script>if(window.opener) { window.opener.after_auth(); window.close(); }</script>"
  end
end


