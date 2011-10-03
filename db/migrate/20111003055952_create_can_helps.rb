class CreateCanHelps < ActiveRecord::Migration
  def change
    create_table :can_helps do |t|
      t.integer :missing_id
      t.integer :user_id

      t.timestamps
    end
  end
end
