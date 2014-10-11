class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.text		:name
      t.text		:description
    end
  end
end
