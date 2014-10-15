class PublicController < ApplicationController
	layout "public"
	def index
		status = Status.find_by_name("Publish")
		@events = Event.where("status_id = ?", status.id)
	    # @events = Event.find_by_status_id(status.id)
	    @event = Event.new() if @events.nil?	 # Don't overwrite user input if already in memory.
	    @related = get_related
	    @coords = ""

	    if !@events
	      	flash[:warning] = "No events found"
	      	@event ||= [Event.new]    # Just to keep things happy
	    end
	end

	def create
		@event = Event.new(event_params)

		# Add stuff behind the curtain
		@event.start_date = Time.now
		@event.title = "Crowd-sourced report"
		@event.created_by = "public"
		@event.status = Status.find_by_name("public")
		@event.event_type = EventType.find_by_name("Current")
		@event.district = District.find_by_name("Unknown")
		@event.severity = Severity.find_by_name("Normal")
		@event.owner = Owner.find_by_name("public")
		@event.traffic_pattern = TrafficPattern.find_by_name("None")
		@event.status = Status.find_by_name("Reported")

		@related = get_related
    
	    # Build spatial location (Assume we are only creating point features for the moment)
	    coords = params["coords"].split(" ")
	    if coords.size != 2
	      flash.now[:error] = "No location specified on the map"
	      index
		  render 'index'
	    else
	      # Add geography to location table
	      factory = Location.rgeo_factory_for_column(:geom)
	      # geom = Location.create(:geom => factory.collection(
	      #       [factory.point(coords[1],coords[0])]),    # coord order: x (longitude), y (latitude)
	      #       :created_by => "public")
		  geom = Location.create(:latitude => coords[0].to_f, :longitude => coords[1].to_f, :created_by => "public")
	      if !geom
	      	flash[:error] = "Error creating point record.  Your report was not saved."
			redirect_to :action => :index
	      else
	        # Continue to save event record
	        @event.location = geom

	        if @event.save
	          flash[:notice] = "Information reported successfully. Thank you for your help!"
			  redirect_to :action => :index
	        else
	          flash[:error] = "Failed to save the report!"
	          geom.destroy  # Delete geometry we saved earlier.
			  redirect_to :action => :index
	        end
	      end
	    end
	end

	private

	  def event_params
	    # Block timestamps
	    params.require(:event).permit(:road, :direction_id, :event_type_id, :start_date, 
	              :title, :description, :traffic_pattern_id, :location, :status_id, :created_by)
	  end

	  # Get related data needed for display
	  def get_related
	    data = {:directions => Direction.all,
	            :severities => Severity.all,  
	            :event_types => EventType.all,
	            :traffic_patterns => TrafficPattern.all
	          }
	  end

end
