class DropQuestionsAnswers < ActiveRecord::Migration
  def up                                                           
    drop_table :questions_answers
  end

  def down
  end
end
