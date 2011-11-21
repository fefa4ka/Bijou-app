class DropQuestionAnswers < ActiveRecord::Migration
  def up                         
    drop_table :question_answers
  end

  def down
  end
end
