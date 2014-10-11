class CreateRoles < ActiveRecord::Migration
  def up
    create_table :roles do |t|
      t.text :name, :null => false
      t.text :description, :null => false
    end
  end

  def down
  	drop_table :roles
  end
end
