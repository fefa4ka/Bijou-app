class Discussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :discussion
  belongs_to :missing             
  
  has_many :discussions 
  
  validates :comment, :presence => true
end
