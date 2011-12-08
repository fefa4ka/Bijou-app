class User < ActiveRecord::Base    
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # TODO: сделать validable, и убрать правила на пароль. Может сломаться создание гостевого пользователя, не работал User.save(false)
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, 
         :omniauthable
 
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :phone, :callback, :password, :password_confirmation, :remember_me,
                  :admin, :detective, :volunteer,
                  :last_visit
                  
  
  has_attached_file :avatar, :url => '/users/:style/:id', :styles => { :thumb => "100x100#", :small => "160x160#", :medium => "300x300>", :large => "700x700>" } 
  
  has_many :missings, :dependent => :destroy
  has_many :discussions, :dependent => :destroy
  has_many :messages
  has_many :can_helps, :dependent => :destroy 
                       
  def has_missing?
     self.missings.length > 0 ? true : false
  end                                  
  
  def last_visit(type, id)
    record = Impression.where(:user_id => self.id, :impressionable_type => type, :impressionable_id => id).last
    record.created_at
  end            
  
  def last_visit=
  end
   
end
