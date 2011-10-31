class User < ActiveRecord::Base      
  has_many :missings, :dependent => :destroy
  has_many :discussions, :dependent => :destroy
  has_many :messages
  has_many :can_helps, :dependent => :destroy    
             
  authenticates_with_sorcery!
  
  attr_accessor :email, :password, :password_confirmation

  # hashes
  attr_accessor :callback_phone, :callback_email
   
  # for detectives
  attr_accessor :detective_license, :specialization_additional, :specialization_1, :specialization_2, :specialization_3, :coverage   
  
  # validates_confirmation_of :password
  validates_presence_of :password
  validates_presence_of :email
  validates_uniqueness_of :phone           
  
  has_attached_file :avatar, :url => '/users/:style/:id', :styles => { :thumb => "100x100#", :small => "160x160#", :medium => "300x300>", :large => "700x700>" }                         
  
  def to_param
    "#{id}-#{username.parameterize}"
  end    
  
  def has_missing?
    self.missings.length > 0 ? true : false
  end
  
end
