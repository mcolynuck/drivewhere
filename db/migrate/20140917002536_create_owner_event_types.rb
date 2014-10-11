class CreateOwnerEventTypes < ActiveRecord::Migration
  def up
    create_table :owner_event_types, :id => false do |t|
      t.references :owner
      t.references :event_type
      t.text    "created_by"
      t.text    "updated_by"
      t.timestamps
    end
    add_index :owner_event_types, ["owner_id", "event_type_id"]
  end

  def down
  	drop_table("owner_event_types")
  end
end
