class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

#    sign_in_and_redirect @user, :event => :authentication
    sign_in_and_close_popup @user
  end

  def google
    @user = find_for_open_id(request.env["omniauth.auth"], current_user)
    
    sign_in_and_close_popup @user
  end
  
  def find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    find_or_create(data.email, data.name, :facebook)
  end

  def find_for_open_id(access_token, signed_in_resource=nil)
    data = access_token.info
    find_or_create(data["email"], data["name"])
  end
   
  def find_or_create(email, name="", provider="")
    if user = User.where(:email => email).first
      user
    elsif session[:guest_user_id]
      user.email = email
      user.name = name
      user.save
      user
    else
      user = User.create!(:email => email, :name => name, :password => Devise.friendly_token[0,20])
    end
    user.provider = provider
    user.save
    user
  end

  private

  def sign_in_and_close_popup(user)
    sign_in user
    
    render :inline => "<script>if(window.opener) { window.opener.location.reload(true); window.close() }</script>"
  end
end


