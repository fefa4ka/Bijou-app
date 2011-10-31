class AddDateToMissing < ActiveRecord::Migration
  def change
    add_column :missings, :date, :date
  end
end
