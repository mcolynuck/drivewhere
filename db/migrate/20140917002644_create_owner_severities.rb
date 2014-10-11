class CreateOwnerSeverities < ActiveRecord::Migration
  def up
    create_table :owner_severities, :id => false do |t|
      t.references :owner
      t.references :severity
      t.text    "created_by"
      t.text    "updated_by"
      t.timestamps
    end
    add_index :owner_severities, ["owner_id", "severity_id"]
  end

  def down
  	drop_table("owner_severities")
  end
end
