class CreateSeenTheMissings < ActiveRecord::Migration
  def change
    create_table :seen_the_missings do |t|
      t.integer :missing_id
      t.integer :user_id
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
