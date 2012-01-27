class Message < ActiveRecord::Base

  has_many :messages

  is_private_message
  
  # The :to accessor is used by the scaffolding,
  # uncomment it if using it or you can remove it if not
  #attr_accessor :to
  attr_accessor :from, :to, :to_message, :name, :email, :phone
  
end
