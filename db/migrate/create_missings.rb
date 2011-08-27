class CreateMissings < ActiveRecord::Migration
  def self.up
  	drop_table :missings
    create_table :missings do |t|
      t.string :man_name
      t.text :description
      t.boolean :man_gender
      t.date :man_birthday
      t.text :man_char_hash
      t.string :author_name
      t.string :author_phone
      t.string :author_email
      t.integer :author_callback_hash
      t.integer :missing_private_hash
      t.string :missing_password

      t.timestamps
    end
  end

  def self.down
    drop_table :missings
  end
end
