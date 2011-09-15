class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps
      t.string :name
      t.text :description
      t.references :missing

      t.timestamps
    end
    add_index :places, :missing_id
  end
end
