class Familiar < ActiveRecord::Base
  belongs_to :missings
  validates :name, :presence => true
end
