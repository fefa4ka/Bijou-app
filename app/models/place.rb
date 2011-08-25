class Place < ActiveRecord::Base
  belongs_to :missings
  acts_as_gmappable
  validates :address, :presence => true

  def gmaps4rails_address
    self.address
  end
end
