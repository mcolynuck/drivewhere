class EventType < ActiveRecord::Base
	has_many :owner_event_types
end
