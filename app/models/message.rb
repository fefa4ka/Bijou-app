class Message < ActiveRecord::Base
  belongs_to :user     
  belongs_to :message
  has_many :messages
  
  attr_accessor :answer_to
  
  def convert_from_answer   
  	if self.answer_to
	    parent = Message.find(self.answer_to)
	    unless parent.nil?
	      self.message_id = parent.id
	      self.destination_user_id = parent.user_id
	    end
	end
  end
  
  # typograf :message, :use_p => true, :use_br => true, :encoding => "UTF-8"
end
