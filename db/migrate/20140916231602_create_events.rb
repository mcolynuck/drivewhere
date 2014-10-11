class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
	    t.text    	 :road
	    t.references :district			# FK to districts
	    t.references :direction			# FK to directions
	    t.references :event_type		# FK to event_types
	    t.references :severity			# FK to severities
	    t.timestamp	 :start_date
	    t.timestamp  :end_date
	    t.text    	 :title
	    t.text    	 :description
	    t.references :traffic_pattern	# FK to traffic_pattern
	    t.references :owner				# FK to owners
	    t.references :status			# FK to statuses
	    t.references :location  		# FK to locations
	    t.text    	 :created_by
	    t.text    	 :updated_by
	    t.timestamps
    end    
    add_index :events, [:owner_id, :event_type_id, :severity_id], name: 'events_owner_evtype_severity'
  end

  def down
  	drop_table("events")
  end
end