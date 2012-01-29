class SeenTheMissing < ActiveRecord::Base
  belongs_to :missing
  belongs_to :user

  before_save :geocoding

  private

  def geocoding
    result = Geocoder.search self.address

    if result.size > 0
      self.latitude = result.first.latitude
      self.longitude = result.first.longitude
    end
  end


end
