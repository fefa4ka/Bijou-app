class Place < ActiveRecord::Base
  belongs_to :missing             
  has_many :can_helps, :through => :can_helps_places             
                     
  validates :address, :presence => true  

  before_save :geocode

  
  private 
  def geocode
    geo_result = Geocoder.search("#{self.latitude},#{self.longitude}").first

    self.country = geo_result.country
    self.state = geo_result.state
    self.city = geo_result || geo_result.city
    
    self.address = geo_result.address if self.address.nil?
    geo_result
  end
end
