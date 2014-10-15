class Location < ActiveRecord::Base
	has_one 	:event

   validates_associated :event

#TODO: When going back to spaital db, put code below in appropriate html files in script section.
#    // Should work for point and multipoint but no other types yet.
#    <% @event.location.each {|g| %>
#      <%= raw 'xxxMap.addMarker("'+g.latitude.to_s+' '+g.longitude.to_s+'", 17, true);' %>
#    <% } %>

#TODO: Remarked out code sections below for non-spatial db.
#      Using float columns for latitude & longitude instead of geometry collection column.

	# By default, use the GEOS implementation for spatial columns.
#    self.rgeo_factory_generator = RGeo::Geos.factory_generator
    
    # But use a geographic implementation for the spatial column.
#    set_rgeo_factory_for_column(:geom, RGeo::Geographic.spherical_factory(:srid => 4326))


    def num_geometries
#    	self.geom.num_geometries
    end

    #TODO: This assumes a single geometry in the collection.  Should take param for index or create a list of types?
    def geom_type
#    	self.geom.geometry_n(0).geometry_type
        "Point"     # Hard-coding for non-spaital database deployment
    end

    #TODO: This assumes a single point so needs to be updated to handle anything else!
    def geom_coords
#      self.geom.geometry_n(0).y.to_s + " " + self.geom.geometry_n(0).x.to_s
        "" + self.latitude.to_s + " " + self.longitude.to_s
    end

end
