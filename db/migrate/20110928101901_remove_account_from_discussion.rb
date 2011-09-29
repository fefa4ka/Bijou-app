class RemoveAccountFromDiscussion < ActiveRecord::Migration
  def up
    remove_column :discussions, :account_id
  end

  def down
    add_column :discussions, :account_id, :integer
  end
end
