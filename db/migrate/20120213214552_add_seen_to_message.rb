class AddSeenToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :seen_the_missing_id, :integer
  end
end
