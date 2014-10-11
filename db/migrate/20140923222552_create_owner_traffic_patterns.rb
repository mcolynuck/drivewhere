class CreateOwnerTrafficPatterns < ActiveRecord::Migration
  def change
    create_table :owner_traffic_patterns, :id => false do |t|
      t.references :owner
      t.references :traffic_pattern
      t.text    "created_by"
      t.text    "updated_by"
      t.timestamps
    end
    add_index :owner_traffic_patterns, ["owner_id", "traffic_pattern_id"]
  end
end
