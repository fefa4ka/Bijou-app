class CreateMissings < ActiveRecord::Migration
  def self.up
    create_table :missings do |t|
      t.string :name
      t.text :description
      t.string :image_url

      t.timestamps
    end
  end

  def self.down
    drop_table :missings
  end
end
