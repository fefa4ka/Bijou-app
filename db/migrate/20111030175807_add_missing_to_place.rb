class AddMissingToPlace < ActiveRecord::Migration
  def change
    add_column :places, :missing, :boolean
  end
end
