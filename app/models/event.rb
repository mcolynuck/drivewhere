class Event < ActiveRecord::Base
	belongs_to		:owner
	belongs_to		:event_type
	belongs_to     	:severity
	belongs_to		:district
	belongs_to		:direction
	belongs_to     	:location
	belongs_to		:traffic_pattern
    belongs_to      :status

	validates_presence_of :title
	validates_presence_of :description

    def published?
        status_id == Status.find_by_name("Publish").id
    end

    def user_accessible?(user_id)
        unless owner.users
            return false
        end
        u = User.find(user_id)
        if u
            if owner.users.include?(u)
        	   return true		# User is an owner
            else
        	   if u.role.name == "admin"
        		  return true		# User is 'admin'
        	   end
            end
        end
        return false
    end

    # Format message output for balloon.
    def format
        '<div class="evName">'+event_type.name+'</div><div class="evRoad">'+road+'</div><div class="evDescription">'+description+'</div>'
    end
end