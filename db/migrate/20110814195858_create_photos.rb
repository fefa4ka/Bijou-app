class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :missing_id
      t.string :image_name

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
