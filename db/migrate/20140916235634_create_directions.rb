class CreateDirections < ActiveRecord::Migration
  def change
    create_table :directions do |t|
        t.text    "name"
        t.text    "description"
    end
  end
end
