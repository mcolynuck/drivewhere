class EventsController < ApplicationController

  layout "event"

  before_action :confirm_logged_in
  before_action :confirm_user_access, :except => [:index, :show, :new, :create]


  def index
    # Filter events by owner or spatially?
    if session[:user_role] == "admin"
      @events = Event.all
    else    # Filter by owner id
      @events = Event.where(owner_id: User.find(session[:user_id]).owner.id)
    end

    if !@events
      flash[:warning] = "No events found"
      @event ||= [Event.new]    # Just to keep things happy
    end
  end


  def show
    @event = Event.find(params[:id])
    if !@event
      flash[:warning] = "Could not find event with id [#{params[:id]}]"
      render('index')
    end
  end


  def new
    @event = Event.new

    # Prep other data on form
    @related = get_related
    @coords = ""

    # Owner should be fixed for this session
    #   -a global variable or something like that?
  end


  def create
    @event = Event.new(event_params)

    # Define the user if not admin since select list won't be available to anyone else.
    if session[:user_role] != "admin"
      user = User.find(session[:user_id])
      @event.owner = user.owner
    end

    @event[:created_by] = session[:user_name]

    # Prepare in case we have to render later because of an error.
    @related = get_related
    @coords = params[:coords]


    # Build spatial location (Assume we are only creating point features for the moment)
    coords = @coords.split(" ")
    if coords.size != 2
      @event.errors.add(:coords, "Two coordinates required without commas.")
      render("new")
    else
      # Add geography to location table
      factory = Location.rgeo_factory_for_column(:geom)
      geom = Location.create(:geom => factory.collection(
            [factory.point(coords[1],coords[0])]),    # coord order: x (longitude), y (latitude)
            :created_by => session[:user_name])
      if !geom
        render(:action => 'new')
      else
        # Continue to save event record
        @event.location = geom

        if @event.save
          flash[:notice] = "New event created successfully"
          redirect_to(:action => 'show', :id => @event.id)
        else
          geom.destroy  # Delete geometry we saved earlier.
          render('new')
        end
      end
    end
  end


  def edit
    @event = Event.find(params[:id])
    @related = get_related
    @owner_prefs = get_owner_prefs
    @coords = @event.location.geom.geometry_n(0).y.to_s + ' ' + @event.location.geom.geometry_n(0).x.to_s

    if !@event
      flash[:warning] = "Could not find event with id [#{params[:id]}]"
      render('index')
    end
  end


  # update should likely archive existing record and add a new one so we maintain history
  def update
    # Need validation for coordinates:
    #   -Correct number of numbers for the spatial type
    @event = Event.find(params[:id])
    if !@event
      flash[:warning] = "Could not find event with id [#{params[:id]}]"
    else
      eparams = event_params

      @event[:updated_by] = session[:user_name]

      # Build spatial location (Assume we are only creating point features for the moment)
      coords = params[:coords].split(" ")
      if coords.size != 2
        flash[:error] = "Two coordinates required, no commas"
        redirect_to(:action => "edit", :id => @event.id)
      else
        # Add geography to location table
        factory = Location.rgeo_factory_for_column(:geom)
        geom = @event.location.update_attributes(:geom => factory.collection([factory.point(coords[1],coords[0])]), :updated_by => session[:user_name])
        if !geom
          flash[:error] = "Error saving location data"
          render(:action => 'new')
        else
          if @event.update_attributes(eparams)
            flash[:notice] = "Event updated successfully"
            redirect_to(:action => "show", :id => @event.id)
          else
            render 'edit'
          end
        end
      end
    end
  end


  def delete
    @event = Event.find(params[:id])
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:notice] = "Event deleted successfully"
    redirect_to(:action => "index")
  end

  private   # ------------------------------------------------------------------

  def event_params
    # Block timestamps
    params.require(:event).permit(:owner_id, :road, :district_id, :direction_id, :event_type_id, :severity_id, :start_date, 
              :title, :description, :traffic_pattern_id, :location, :status_id, :created_by, :updated_by)
  end

  # Get related data needed for display
  def get_related
    data = {:owners => Owner.all,
            :directions => Direction.all,
            :severities => Severity.all,  
            :event_types => EventType.all,
            :traffic_patterns => TrafficPattern.all,
            :districts => District.all,
            :spatial_types => SpatialType.all,
            :statuses => Status.all
          }
  end

  # Get owner preferences for display purposes
  def get_owner_prefs
    data = {:owner_severities => sort_group_prefs({:data => OwnerSeverity.all, :column => "severity_id"}),
            :owner_event_types => sort_group_prefs({:data => OwnerEventType.all, :column => "event_type_id"}),
            :owner_traffic_patterns => sort_group_prefs({:data => OwnerTrafficPattern.all, :column => "traffic_pattern_id"}),
            :owner_districts => sort_group_prefs({:data => OwnerDistrict.all, :column => "district_id"})
    }
  end

  # Retrieve and sort owner preference data
  def sort_group_prefs(params)
    output = Array.new
    params[:data].group_by(&:owner_id).sort.each do |rec, o_s|
      data = Array.new
      o_s.sort{|a,b| a[params[:column]] <=> b[params[:column]]}.each do |s|
        data << s[params[:column]]
      end
      output << {:owner_id => rec, :data => data}
    end
    return output
  end    


  # User must be an owner to perform certain operations
  def confirm_user_access
    begin
        event = Event.find(params[:id])
    rescue
      flash[:notice] = "Cannot locate event #{params[:id]}."
      redirect_to :action => :index
      return false
    end
    unless event.user_accessible?(session[:user_id])
      flash[:error] = "You do not own that event."
      redirect_to :action => :index
    end    
  end  
end
