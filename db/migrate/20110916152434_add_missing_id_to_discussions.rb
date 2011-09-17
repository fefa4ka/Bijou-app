class AddMissingIdToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :missing_id, :integer
  end
end
