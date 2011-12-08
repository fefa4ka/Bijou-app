class Missing < ActiveRecord::Base         
  is_impressionable
  
  belongs_to :user
  
  has_many :photos, :dependent => :destroy
  has_many :discussions, :dependent => :destroy   
  
  has_many :missings_histories
  has_many :can_helps 

  attr_writer :current_step  

  # Поля характеристик
  attr_accessor :man_age,
                :author_callback_phone, :author_callback_email, :private_history, :private_contacts, :photos_attributes, :author_name, :author_email, :author_phone, :author_callback_email, :author_callback_phone, :author_callback_hash, :missing_password,
                :questions
  
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :photos

 
  
                            
  # typograf :decription, :use_p => true, :use_br => true, :encoding => "UTF-8"
  
  after_find :prepare_data                                                                                
  
  default_scope :order => "updated_at DESC"
                             
  def to_param                 
    "#{id}-#{name.parameterize}/"
  end
                 
  def last_visit
    @current_user.last_visit("Missing", self.id)
  end
  
  def answers(user, type = :all)
  	Question.asnwer_for(self, user, type)
  end
  	
  def places(user = current_or_guest_user)
  	answers = self.answers(user, 4)

  end
  


  def current_step
    @current_step || steps.first
  end                                                                                                                                 
                                                          
  def next_step
    next_step = steps[steps.index(current_step)+1] || ""
  end
  
  def previous_step
    previous_step = steps[steps.index(current_step)-1] || ""
  end
  
  def first_step?
    current_step == steps.first
  end
  
  def last_step?
    current_step == steps.last
  end            
       
  private               
    def steps
      %w[common history contacts]
    end
    
    def prepare_data
      now = Date.today
      self.man_age = now.year - self.birthday.year if self.birthday.is_a?(Date)       
    end  
end                                
