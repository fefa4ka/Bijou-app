require 'open-uri'

class User < ActiveRecord::Base    
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # TODO: сделать validable, и убрать правила на пароль. Может сломаться создание гостевого пользователя, не работал User.save(false)
  
  devise :database_authenticatable, :registerable,
         :confirmable,
         :recoverable, :rememberable, :trackable, 
         :omniauthable
 
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :phone, :callback, :password, :password_confirmation, :remember_me,
                  :admin, :detective, :volunteer,
                  :last_visit
                
  attr_accessor :old_password

  has_attached_file :avatar, :url => '/users/:style/:id', :styles => { :thumb => "100x100#", :small => "160x160#", :medium => "300x300>", :large => "700x700>" } 

  has_private_messages
  
  has_many :missings, :dependent => :destroy
  has_many :discussions, :dependent => :destroy
  has_many :histories, :dependent => :destroy
  has_many :seen_the_missings, :dependent => :destroy
  
                       
  def has_missing?
     self.missings.where(:published => true).size > 0 ? true : false
  end                                  
  
  def avatar_from_url(url) 
    self.avatar = open(url)
  end

  def last_visit(type, id)
    record = Impression.where(:user_id => self.id, :impressionable_type => type, :impressionable_id => id).last
    record.created_at rescue nil
  end       
  
  def self.destroy_unless
    User.all.each do |u|
      if u.missings.size == 0 && u.discussions.size == 0 && u.histories.size == 0 && u.seen_the_missings.size == 0 && (u.name == "guest" || (u.confirmation_sent_at + 2.days > DateTime.now))
        u.destroy
      end
    end
  end
    

end
