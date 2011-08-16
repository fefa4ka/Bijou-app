class Missing < ActiveRecord::Base
  has_many :photos, :dependent => :destroy
  has_many :places
  has_many :persons
  
  attr_writer :current_step
  
  # Поля характеристик
  attr_accessor :man_growth, :man_physique, :man_hair_color, :man_hair_length, :man_specials_1, :man_special_2, :man_special_3, :man_specials
  
  accepts_nested_attributes_for :photos
  

  def current_step
    @current_step || steps.first
  end
  
  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end
  
  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
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
