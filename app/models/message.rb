class Message < ActiveRecord::Base
  belongs_to :user     
  
  # typograf :message, :use_p => true, :use_br => true, :encoding => "UTF-8"
end
