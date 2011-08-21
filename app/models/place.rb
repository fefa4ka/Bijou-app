class Place < ActiveRecord::Base
  acts_as_gmappable
  
  def gmaps4rails_address
     "#{self.street}" 
   end
end
