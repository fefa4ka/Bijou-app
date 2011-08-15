class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.integer :missing_id
      t.string :name
      t.integer :relations
      t.integer :relations_type
      t.text :relations_description
      t.text :description
      t.boolean :last_contact

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
