module ReportHelper
  def current_user_timeline    
    if user_signed_in?
      @inbox = @timeline = current_user.received_messages  
      @missings = []       
      @message = Message.new        
      if current_user.missings.length > 0
        current_user.missings.each do |missing| 
          @missings.push(missing)  
          @timeline = @timeline + missing.seen_the_missings
          @timeline = @timeline + missing.can_helps
        end
      end                     
      @timeline = @timeline.sort_by(&:created_at).reverse       
    end
  end    

  def current_user_timeline_fresh
    current_user_timeline.select {|record| record["created_at"].to_time.to_i > current_user.last_sign_in_at.to_time.to_i}      
  end

end
