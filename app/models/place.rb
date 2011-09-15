class Place < ActiveRecord::Base
  belongs_to :missing
  acts_as_gmappable :process_geocoding => true, :check_process => true
  validates :address, :presence => true
  validates :name, :presence => true
  
  def gmaps4rails_address
    self.address
  end
end
