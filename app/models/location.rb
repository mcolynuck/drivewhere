class Location < ActiveRecord::Base
	has_one 	:event

   validates_associated :event

	# By default, use the GEOS implementation for spatial columns.
    self.rgeo_factory_generator = RGeo::Geos.factory_generator
    
    # But use a geographic implementation for the spatial column.
    set_rgeo_factory_for_column(:geom, RGeo::Geographic.spherical_factory(:srid => 4326))


    def num_geometries
    	self.geom.num_geometries
    end

    #TODO: This assumes a single geometry in the collection.  Should take param for index or create a list of types?
    def geom_type
    	self.geom.geometry_n(0).geometry_type
    end

    #TODO: This assumes a single point so needs to be updated to handle anything else!
    def geom_coords
      self.geom.geometry_n(0).y.to_s + " " + self.geom.geometry_n(0).x.to_s
    end

end
