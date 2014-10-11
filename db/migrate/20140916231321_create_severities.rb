class CreateSeverities < ActiveRecord::Migration
  def up
  	create_table :severities do |t|
	    t.text    :name
	    t.text 	  :description
  	end
  end

  def down
  	drop_table("severities")
  end
end