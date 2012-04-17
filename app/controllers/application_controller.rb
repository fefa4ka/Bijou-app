# encoding: utf-8

require 'net/http'

class ApplicationController < ActionController::Base
  protect_from_forgery                         
  
  before_filter :copy_data_from_guest, :mailer_set_url_options

  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id]
        logging_in
        guest_user.destroy unless session[:guest_user_id] == current_user.id
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user
    User.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_guest_user.id : session[:guest_user_id])
  end                                 
 
  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.            
  def logging_in                
    copy_data_from_guest(current_user)
  end
  
  private
  def create_guest_user
    u = User.new(:name => "guest", :email => "guest_#{Time.now.to_i}#{rand(99)}@guest_email_address.com")
    u.confirmed_at = DateTime.now
    u.save()
    u
  end

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
  
  def copy_data_from_guest     
    if session[:guest_user_id] && User.exists?(session[:guest_user_id]) && current_user    
      associations = User.reflect_on_all_associations(:has_many).collect {|a| a.name }   
      associations.each do |a|    
        guest_user.method(a).call.each do |record|    
          if a == :sent_messages
            record.sender_id = current_user.id
          elsif a == :received_messages          
            record.recipient_id = current_user.id
          else
            record.user_id = current_user.id 
          end
          record.save    
        end        
      end
                
      guest_user.destroy unless session[:guest_user_id] == current_user.id            
      session[:guest_user_id] = nil
    elsif session[:guest_user_id] && !User.exists?(session[:guest_user_id])
      session[:guest_user_id] = nil
    end
  end  

 end
