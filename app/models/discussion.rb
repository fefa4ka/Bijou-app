class Discussion < ActiveRecord::Base
  belongs_to :account
  belongs_to :discussion
  belongs_to :missing
end
