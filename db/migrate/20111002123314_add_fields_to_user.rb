class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :coverage, :text
    add_column :users, :specialization, :text
    add_column :users, :type, :integer
  end
end
