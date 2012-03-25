class Answer < ActiveRecord::Base       
  belongs_to :questions
  has_many :histories       
  has_many :nested_questions, :class_name => "RelatedQuestion", :foreign_key => "answer"
          
  
  accepts_nested_attributes_for :nested_questions
end
