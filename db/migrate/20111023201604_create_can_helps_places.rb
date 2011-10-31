class CreateCanHelpsPlaces < ActiveRecord::Migration
  def change
    create_table :can_helps_places do |t|
      t.references :place
      t.references :can_help

      t.timestamps
    end
    add_index :can_helps_places, :place_id
    add_index :can_helps_places, :can_help_id
  end
end
