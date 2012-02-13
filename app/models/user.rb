require 'open-uri'

class User < ActiveRecord::Base    
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # TODO: сделать validable, и убрать правила на пароль. Может сломаться создание гостевого пользователя, не работал User.save(false)
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, 
         :omniauthable
 
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :phone, :callback, :old_password, :password, :password_confirmation, :remember_me,
                  :admin, :detective, :volunteer,
                  :last_visit

  attr_accessor :image_url

  has_attached_file :avatar, :url => '/users/:style/:id', :styles => { :thumb => "100x100#", :small => "160x160#", :medium => "300x300>", :large => "700x700>" } 

  has_private_messages
  
  has_many :missings, :dependent => :destroy
  has_many :discussions, :dependent => :destroy
  has_many :can_helps, :dependent => :destroy          
  has_many :histories, :dependent => :destroy
  has_many :seen_the_missings, :dependent => :destroy
  
                       
  def has_missing?
     self.missings.where(:published => true).size > 0 ? true : false
  end                                  
  
  def last_visit(type, id)
    record = Impression.where(:user_id => self.id, :impressionable_type => type, :impressionable_id => id).last
    record.created_at
  end         
  
  def avatar_from_url(url) 
    self.avatar = open(url)
  end
 
  
end
