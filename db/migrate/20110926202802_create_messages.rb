class CreateMessages < ActiveRecord::Migration
  def change                    
    create_table :messages do |t|
      t.text :message
      t.string :name
      t.string :email
      t.string :phone
      t.references :account

      t.timestamps
    end
    add_index :messages, :account_id
  end
end
