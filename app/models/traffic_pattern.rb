class TrafficPattern < ActiveRecord::Base
	has_many	:owner_traffic_patterns
	has_many	:owners, :through => :owner_traffic_patterns
	has_many 	:events
end
