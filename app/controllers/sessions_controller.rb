class SessionsController < ApplicationController     
  protect_from_forgery
  include SessionsHelper
  
  def create
     resource = warden.authenticate!(:scope => :user, :recall => :failure)
     return sign_in_and_redirect(:user, resource)
   end

   def sign_in_and_redirect(resource_or_scope, resource=nil)
     scope = Devise::Mapping.find_scope!(resource_or_scope)
     resource ||= resource_or_scope
     sign_in(scope, resource) unless warden.user(scope) == resource
     return render :json => { :success => true, :redirect => after_sign_in_path_for(scope) || stored_location_for(scope) }
   end

   def destroy
     sign_out       
     redirect_to '/'
   end      
   
   # Customize the Devise after_sign_in_path_for() for redirecct to previous page after login
   def after_sign_in_path_for(resource_or_scope)
     case resource_or_scope
     when :user, User
       store_location = session[:return_to]
       clear_stored_location
       (store_location.nil?) ? "/" : store_location.to_s
     else
       super
     end
   end
   
end
