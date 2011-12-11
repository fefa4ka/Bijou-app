class Answer < ActiveRecord::Base       
  belongs_to :questions
  has_many :histories
end
