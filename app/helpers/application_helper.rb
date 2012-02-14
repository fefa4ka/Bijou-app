module ApplicationHelper     
  def omniauth_providers
    %w{ odnoklassniki vkontakte facebook twitter yandex facebook }
    %w{ vkontakte facebook yandex mailru google  }
  end
             
  def current_user_timeline    
    if user_signed_in?
      @inbox = @timeline = current_user.received_messages  
      @missings = []       
      @message = Message.new        
      if current_user.missings.length > 0
        current_user.missings.each do |missing| 
          @missings.push(missing)  
          @timeline = @timeline + missing.seen_the_missings
        end
      end                     
      @timeline = @timeline.sort_by(&:created_at).reverse       
    end
  end    
  
  def current_user_timeline_fresh
    current_user_timeline.select {|record| record["created_at"].to_time.to_i > current_user.last_sign_in_at.to_time.to_i}      
  end
  
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
