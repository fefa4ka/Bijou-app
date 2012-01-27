class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :confirmed, :boolean
  end
end
