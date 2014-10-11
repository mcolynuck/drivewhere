class CreateOwnerDistricts < ActiveRecord::Migration
  def up
    create_table :owner_districts, :id => false do |t|
      t.references :owner
      t.references :district
      t.text    "created_by"
      t.text    "updated_by"
      t.timestamps
    end
    add_index :owner_districts, ["owner_id", "district_id"]
  end

  def down
  	drop_table("owner_districts")
  end
end
