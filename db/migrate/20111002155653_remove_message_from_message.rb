class RemoveMessageFromMessage < ActiveRecord::Migration
  def up
    remove_column :messages, :message
    add_column :messages, :text, :text
  end

  def down
    add_column :messages, :message_id, :integer
  end
end
