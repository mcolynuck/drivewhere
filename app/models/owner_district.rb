class OwnerDistrict < ActiveRecord::Base
	belongs_to		:owner
	belongs_to		:district
	has_many		:events
end
