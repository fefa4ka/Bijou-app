class RelatedQuestion < ActiveRecord::Base
  belongs_to :question    
  belongs_to :related_question, :class_name => "Question", :foreign_key => "related_question_id"
end
