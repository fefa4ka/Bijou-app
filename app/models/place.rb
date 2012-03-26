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
    self.city = geo_result.city rescue nil
    
    self.address = geo_result.address if self.address.nil?  
    self.street = get_street
    geo_result
  end  
  
  def get_street  
    street = []
    self.address.split(', ').each {|e| street.push(e) unless [self.country, self.state, self.city].include?(e) }
    street.join(", ")
  end  
end
