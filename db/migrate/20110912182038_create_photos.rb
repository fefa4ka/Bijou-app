class CreatePhotos < ActiveRecord::Migration
  def change
#    drop_table :photos
      create_table :photos do |t|
      t.string :image_name
      t.references :missing

      t.timestamps
    end
    add_index :photos, :missing_id
  end
end
