class CreateCollectionsQuestions < ActiveRecord::Migration
  def change
    create_table :collections_questions do |t|
      t.integer :question_id
      t.integer :collection_id
    end
  end
end
