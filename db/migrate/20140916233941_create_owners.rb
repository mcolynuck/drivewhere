class CreateOwners < ActiveRecord::Migration
  def up
    create_table :owners do |t|
	    t.text    "name", :null => false
	    t.text 	  "description"
	    t.text    "contact_first"
	    t.text    "contact_last"
	    t.text    "address_1"
	    t.text    "address_2"
	    t.text    "city"
	    t.text    "region"			# Province, State, etc.
	    t.text    "country"
	    t.text    "postal"			# postal code, zip, etc.
	    t.text    "phone"
	    t.text    "email"
	    t.boolean :active, :default => true
	    t.text    "created_by"
	    t.text    "updated_by"
        t.timestamps
    end
  end
  def down
  	drop_table("owners")
  end
end
