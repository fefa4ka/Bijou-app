class User < ActiveRecord::Base      
  has_many :missings
  has_many :discussions
  has_many :messages
  
  has_many :can_helps    
  has_many :missings, :through => :can_helps, :as => :missings_i_help
             
  authenticates_with_sorcery!
  
  attr_accessor :email, :password, :password_confirmation

  # hashes
  attr_accessor :callback_phone, :callback_email
   
  # for datectives
  attr_accessor :detective_license, :specialization_additional, :specialization_1, :specialization_2, :specialization_3, :coverage   
  
  #  validates_confirmation_of :password
  validates_presence_of :password, :on => :create        
  validates_presence_of :email, :on => :create
  validates_uniqueness_of :phone                                    
  
  def to_param
    "#{id}-#{username.parameterize}"
  end    
  
  def has_missing?
    self.missings.length > 0 ? true : false
  end
  
end
