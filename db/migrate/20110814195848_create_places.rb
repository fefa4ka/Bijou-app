class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.integer :missing_id
      t.string :address
      t.float :map_lat
      t.float :map_lon
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :places
  end
end
