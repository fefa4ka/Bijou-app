class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.text :comment
      t.references :account
      t.references :discussion

      t.timestamps
    end
    add_index :discussions, :account_id
    add_index :discussions, :discussion_id
  end
end
