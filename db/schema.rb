# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141015181134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
 # enable_extension "postgis"
 # enable_extension "pgrouting"
 # enable_extension "postgis_topology"
 # enable_extension "address_standardizer"
 # enable_extension "fuzzystrmatch"
 # enable_extension "postgis_tiger_geocoder"

  create_table "directions", force: true do |t|
    t.text "name"
    t.text "description"
  end

  create_table "districts", force: true do |t|
    t.text     "name",       null: false
    t.text     "created_by"
    t.text     "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_types", force: true do |t|
    t.text "name"
    t.text "description"
  end

  create_table "events", force: true do |t|
    t.text     "road"
    t.integer  "district_id"
    t.integer  "direction_id"
    t.integer  "event_type_id"
    t.integer  "severity_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "title"
    t.text     "description"
    t.integer  "traffic_pattern_id"
    t.integer  "owner_id"
    t.integer  "status_id"
    t.integer  "location_id"
    t.text     "created_by"
    t.text     "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["owner_id", "event_type_id", "severity_id"], :name => "events_owner_evtype_severity"

  create_table "events_roles", id: false, force: true do |t|
    t.integer "role_id",  null: false
    t.integer "event_id", null: false
  end

  add_index "events_roles", ["role_id", "event_id"], :name => "index_events_roles_on_role_id_and_event_id"

  create_table "locations", force: true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.text     "created_by"
    t.text     "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "owner_districts", id: false, force: true do |t|
    t.integer  "owner_id"
    t.integer  "district_id"
    t.text     "created_by"
    t.text     "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "owner_districts", ["owner_id", "district_id"], :name => "index_owner_districts_on_owner_id_and_district_id"

  create_table "owner_event_types", id: false, force: true do |t|
    t.integer  "owner_id"
    t.integer  "event_type_id"
    t.text     "created_by"
    t.text     "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "owner_event_types", ["owner_id", "event_type_id"], :name => "index_owner_event_types_on_owner_id_and_event_type_id"

  create_table "owner_severities", id: false, force: true do |t|
    t.integer  "owner_id"
    t.integer  "severity_id"
    t.text     "created_by"
    t.text     "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "owner_severities", ["owner_id", "severity_id"], :name => "index_owner_severities_on_owner_id_and_severity_id"

  create_table "owner_statuses", force: true do |t|
    t.integer  "owner_id"
    t.integer  "status_id"
    t.text     "created_by"
    t.text     "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "owner_statuses", ["owner_id", "status_id"], :name => "index_owner_statuses_on_owner_id_and_status_id"

  create_table "owner_traffic_patterns", id: false, force: true do |t|
    t.integer  "owner_id"
    t.integer  "traffic_pattern_id"
    t.text     "created_by"
    t.text     "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "owner_traffic_patterns", ["owner_id", "traffic_pattern_id"], :name => "index_owner_traffic_patterns_on_owner_id_and_traffic_pattern_id"

  create_table "owners", force: true do |t|
    t.text     "name",                         null: false
    t.text     "description"
    t.text     "contact_first"
    t.text     "contact_last"
    t.text     "address_1"
    t.text     "address_2"
    t.text     "city"
    t.text     "region"
    t.text     "country"
    t.text     "postal"
    t.text     "phone"
    t.text     "email"
    t.boolean  "active",        default: true
    t.text     "created_by"
    t.text     "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.text "name",        null: false
    t.text "description", null: false
  end

  create_table "severities", force: true do |t|
    t.text "name"
    t.text "description"
  end

  create_table "spatial_types", force: true do |t|
    t.text "name"
  end

  create_table "statuses", force: true do |t|
    t.text "name"
    t.text "description"
  end

  create_table "traffic_patterns", force: true do |t|
    t.text "name"
    t.text "description"
  end

  create_table "users", force: true do |t|
    t.text     "name",                                            null: false
    t.text     "password_digest",                                 null: false
    t.datetime "expiry",          default: '2014-10-16 05:21:54', null: false
    t.boolean  "active",          default: true
    t.integer  "owner_id"
    t.integer  "role_id"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "email"
    t.text     "phone"
    t.text     "created_by",                                      null: false
    t.text     "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
