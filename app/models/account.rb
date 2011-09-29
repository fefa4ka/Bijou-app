class Account < ActiveRecord::Base
  has_many :missings
  has_many :discussions
  has_many :messages                                     
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
end
