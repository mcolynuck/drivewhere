class OwnerSeverity < ActiveRecord::Base
	belongs_to		:owner
	belongs_to		:severity
	has_many		:events
end
