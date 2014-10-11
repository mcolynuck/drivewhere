class Severity < ActiveRecord::Base
	has_many	:owner_severities
	has_many	:owners, :through => :owner_severities
	has_many 	:events
end
