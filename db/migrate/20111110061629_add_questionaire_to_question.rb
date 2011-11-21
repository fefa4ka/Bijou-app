class AddQuestionaireToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :questionnaire_id, :integer
    add_column :questions, :position, :integer
  end
end
