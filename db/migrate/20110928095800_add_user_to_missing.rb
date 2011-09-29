class AddUserToMissing < ActiveRecord::Migration
  def change
    add_column :missings, :user_id, :integer
  end
end
