class CreateLocations < ActiveRecord::Migration
  def up
    create_table :locations do |t|
      t.float  :latitude
      t.float  :longitude
      t.text    :created_by
      t.text    :updated_by
      t.timestamps
    end
  end

  def down
    drop_table :locations
  end
end
# class CreateLocations < ActiveRecord::Migration
#   def up
#     create_table :locations do |t|
# 	    t.column  :geom, :geometry_collection
# 	    t.text	  :created_by
# 	    t.text	  :updated_by
#       t.timestamps
#     end
#     change_table :locations do |t|
#         t.index "geom", :spatial => true
#     end
#   end

#   def down
#   	drop_table(:locations)
#   end
# end