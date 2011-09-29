class User < ActiveRecord::Base      
  has_many :missings
  has_many :discussions
  has_many :messages
             
  authenticates_with_sorcery!
  
  attr_accessor :email, :password, :password_confirmation   
  
  #  validates_confirmation_of :password
  validates_presence_of :password, :on => :create        
  validates_presence_of :email, :on => :create
  validates_uniqueness_of :phone                                    
  
  def to_param
    "#{id}-#{username.parameterize}"
  end
end
