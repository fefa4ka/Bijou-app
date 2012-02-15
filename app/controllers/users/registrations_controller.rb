class Users::RegistrationsController < Devise::RegistrationsController

def create
	email = params[resource_name]["email"]
	unless email_exists?(email)
		super
	else
		render :status => :forbidden, :nothing => true
	end
end

private

def email_exists?(email)
	logger.debug("check #{email}")
	User.where(:email => email).size > 0 ? true : false
end


end