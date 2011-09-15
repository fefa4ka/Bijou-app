class Account < ActiveRecord::Base
  has_many :missings
  
end
