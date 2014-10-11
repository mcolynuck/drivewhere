class OwnerEventType < ActiveRecord::Base
	belongs_to		:owner
	belongs_to		:event_type
	has_many		:events
end
