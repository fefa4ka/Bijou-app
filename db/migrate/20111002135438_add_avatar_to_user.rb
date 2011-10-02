class AddAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :image_name, :string
  end
end
