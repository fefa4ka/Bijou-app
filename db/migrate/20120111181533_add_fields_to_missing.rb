class AddFieldsToMissing < ActiveRecord::Migration
  def change
    add_column :missings, :city, :string
    add_column :missings, :history, :text
  end
end
