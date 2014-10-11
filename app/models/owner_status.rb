class OwnerStatus < ActiveRecord::Base
	belongs_to		:owner
	belongs_to		:status
	has_many		:events
end
