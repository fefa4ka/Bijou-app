class HelpType < ActiveRecord::Base           
  has_and_belongs_to_many :can_helps
end
