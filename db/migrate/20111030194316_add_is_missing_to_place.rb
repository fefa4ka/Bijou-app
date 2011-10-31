class AddIsMissingToPlace < ActiveRecord::Migration
  def change
    add_column :places, :is_missing, :boolean
  end
end
