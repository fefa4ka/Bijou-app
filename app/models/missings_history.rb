class MissingsHistory < ActiveRecord::Base
	belongs_to :missing
	belongs_to :question
	belongs_to :user
end
