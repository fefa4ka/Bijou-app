class CanHelp < ActiveRecord::Base                        
  belongs_to :missing
  belongs_to :user           
  
  has_many :can_helps_places
  has_many :places, :through => :can_helps_places
end
