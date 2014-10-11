class CreateSpatialTypes < ActiveRecord::Migration
  def change
    create_table :spatial_types do |t|
      t.text	:name
    end
  end
end
