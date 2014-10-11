class CreateDistricts < ActiveRecord::Migration
  def up
    create_table :districts do |t|
        t.text    "name", :null => false
        t.text    "created_by"
        t.text    "updated_by"
        t.timestamps
    end
  end
  def down
  	drop_table("districts")
  end
end
