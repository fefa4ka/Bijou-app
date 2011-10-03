class RemoveTypeFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :type
    add_column  :users, :role, :integer
  end

  def down
    add_column :users, :type, :integer
  end
end
