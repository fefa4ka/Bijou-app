class AddFieldsToMissing < ActiveRecord::Migration
  def change
    add_column :missings, :age, :integer
    add_column :missings, :last_seen, :date
    add_column :missings, :latitude, :float
    add_column :missings, :longitude, :float
  end
end
