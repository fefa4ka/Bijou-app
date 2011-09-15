class CreateMissings < ActiveRecord::Migration
  def change
    create_table :missings do |t|
      t.string :name
      t.text :description
      t.boolean :gender
      t.date :birthday
      t.text :characteristics
      t.integer :private
      t.references :account

      t.timestamps
    end
    add_index :missings, :account_id
  end
end
