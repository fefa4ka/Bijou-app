class Photo < ActiveRecord::Base
  belongs_to :missings
  
  validates :image_name, :presence => true
end
