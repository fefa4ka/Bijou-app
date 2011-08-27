class CreateFamiliars < ActiveRecord::Migration
  def self.up
    drop_table :familiars
    
    create_table :familiars do |t|
      t.integer :missing_id
      t.string :name
      t.string :relations
      t.integer :relations_quality
      t.text :relation_tense_description
      t.text :description
      t.boolean :seen_last_day

      t.timestamps
    end
  end

  def self.down
    drop_table :familiars
  end
end
