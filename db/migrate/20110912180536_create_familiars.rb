class CreateFamiliars < ActiveRecord::Migration
  def change
#    drop_table :familiars
    create_table :familiars do |t|
      t.string :name
      t.string :relations
      t.string :relations_quality
      t.text :relations_tense_description
      t.text :description
      t.boolean :seen_last_day
      t.references :missing

      t.timestamps
    end
    add_index :familiars, :missing_id
  end
end
