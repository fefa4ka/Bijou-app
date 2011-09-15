class Familiar < ActiveRecord::Base
  belongs_to :missing
  
  validates :name, :presence => true
 
end
