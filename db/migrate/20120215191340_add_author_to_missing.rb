class AddAuthorToMissing < ActiveRecord::Migration
  def change
    add_column :missings, :author_id, :integer
  end
end
