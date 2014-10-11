class OwnerTrafficPattern < ActiveRecord::Base
	belongs_to		:owner
	belongs_to		:traffic_pattern
	has_many		:events
end
