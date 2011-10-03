class CanHelp < ActiveRecord::Base                        
  belongs_to :missing
  belongs_to :user
end
