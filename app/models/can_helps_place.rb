class CanHelpsPlace < ActiveRecord::Base
  validates_presence_of :can_help_id, :place_id
  belongs_to :can_help
  belongs_to :place
end
