class Missing < ActiveRecord::Base
  has_many :photos, :dependent => :destroy
  has_many :places
  has_many :persons
  attr_writer :c
end
