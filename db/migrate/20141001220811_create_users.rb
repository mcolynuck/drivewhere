class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.text        :name, :null => false, :unique => true
      t.text        :password_digest, :null => false
      t.timestamp   :expiry, :null => false, :default => Time.now
      t.boolean     :active, :default => true
      t.references  :owner
      t.references  :role
      t.text        :first_name
      t.text        :last_name
      t.text        :email
      t.text        :phone
      t.text        :created_by, :null => false
      t.text        :updated_by
      t.timestamps
    end
  end

  def down
  	drop_table :users
  end
end
