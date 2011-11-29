class AddPublishedToMissing < ActiveRecord::Migration
  def change
    add_column :missings, :published, :boolean
  end
end
