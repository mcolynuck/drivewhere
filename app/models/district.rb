class District < ActiveRecord::Base
	has_many	:owner_districts
	has_many	:owners, :through => :owner_districts
end
