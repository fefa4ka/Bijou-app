class AddAddressFieldsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :country, :string
    add_column :places, :state, :string
    add_column :places, :city, :string
    add_column :places, :street, :string
  end
end
