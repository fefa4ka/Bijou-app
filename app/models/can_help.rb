class CanHelp < ActiveRecord::Base                        
  belongs_to :missing
  belongs_to :user           
  
  has_many :can_helps_places
  has_and_belongs_to_many :places
  has_and_belongs_to_many :help_types             
  
  accepts_nested_attributes_for :help_types
  
end
  
