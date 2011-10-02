class ReportController < ApplicationController                        
  def index
    @inbox = Message.where("destination_user_id = ?", current_user.id)
  end
  
    
end
