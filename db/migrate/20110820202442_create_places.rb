class CreatePlaces < ActiveRecord::Migration
  def self.up
    drop_table :places
    create_table :places do |t|
      t.integer :missing_id
      t.string :address
      t.float :latitude
      t.float :longtitude
      t.boolean :gmaps
      t.string :name
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :places
  end
end
