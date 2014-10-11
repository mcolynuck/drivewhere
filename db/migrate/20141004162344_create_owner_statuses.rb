class CreateOwnerStatuses < ActiveRecord::Migration
  def up
    create_table :owner_statuses do |t|
      t.references	:owner
      t.references	:status
      t.text		:created_by
      t.text		:updated_by
      t.timestamps
    end
    add_index :owner_statuses, ["owner_id", "status_id"]
  end

  def down
  	drop_table :owner_statuses
  end
end
