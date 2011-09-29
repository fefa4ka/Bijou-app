class RemoveAccountFromMissing < ActiveRecord::Migration
  def up
    remove_column :missings, :account_id
  end

  def down
    add_column :missings, :account_id, :integer
  end
end
