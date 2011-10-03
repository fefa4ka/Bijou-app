class Missing < ActiveRecord::Base         
  is_impressionable
  
  belongs_to :users
  
  has_many :photos, :dependent => :destroy
  has_many :places
  has_many :familiars
  has_many :discussions, :dependent => :destroy   
  
  has_many :can_helps 

  serialize :man_char_hash

  attr_writer :current_step  

  # Поля характеристик
  attr_accessor :man_age, :man_growth, :man_physique, :man_physique_another, :man_hair_color, :man_hair_color_another, :man_hair_length, :man_specials_tattoo, :man_specials_piercing, :man_specials_scar, :man_specials, :author_callback_phone, :author_callback_email, :private_history, :private_contacts, :photos_attributes, :author_name, :author_email, :author_phone, :author_callback_email, :author_callback_phone, :author_callback_hash, :missing_password
  
  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :places, :allow_destroy => true, :reject_if => lambda { |obj| obj[:address].blank? }
  accepts_nested_attributes_for :familiars, :allow_destroy => true, :reject_if => lambda { |obj| obj[:name].blank? }
                            
  # typograf :decription, :use_p => true, :use_br => true, :encoding => "UTF-8"
  
  after_find :expand_data
                             
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  def expand_data
    now = Date.today
    self.man_age = now.year - self.birthday.year if self.birthday.is_a?(Date)
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
  
  def steps
    %w[common characteristic history contacts]
  end              
  
end                                
