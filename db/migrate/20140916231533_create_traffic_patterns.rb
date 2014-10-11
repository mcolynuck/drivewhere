class CreateTrafficPatterns < ActiveRecord::Migration
  def up
  	create_table :traffic_patterns do |t|
	    t.text    "name"
	    t.text 	  "description"
  	end  	
  end

  def down
  	drop_table("traffic_patterns")
  end
end
