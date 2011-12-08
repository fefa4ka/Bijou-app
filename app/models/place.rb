class Place < ActiveRecord::Base
  belongs_to :missing             
  has_many :can_helps, :through => :can_helps_places             
                     
  validates :address, :presence => true  
end
