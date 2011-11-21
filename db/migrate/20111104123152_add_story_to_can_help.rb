class AddStoryToCanHelp < ActiveRecord::Migration
  def change
    add_column :can_helps, :missing_information, :text
    add_column :can_helps, :information, :text
  end
end
