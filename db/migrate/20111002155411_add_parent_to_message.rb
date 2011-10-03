class AddParentToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :message_id, :integer
  end
end
