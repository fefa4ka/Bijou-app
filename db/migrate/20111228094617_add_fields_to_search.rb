class AddFieldsToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :last_seen_start, :date
    add_column :searches, :last_seen_end, :date
  end
end
