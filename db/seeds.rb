# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Severity.create(name: "Normal", description: "Of no special importance")
Severity.create(name: "Minor", description: "Of lowest importance")
Severity.create(name: "Major", description: "Of highest importance")

EventType.create(name: "Current", description: "An active event")
EventType.create(name: "Future", description: "A future event that is not yet active")
EventType.create(name: "Periodic", description: "An event that is currently active and has additional planned future events")

TrafficPattern.create(name: "None", description: "No expected delays")
TrafficPattern.create(name: "Lane Closure", description: "One lane has been closed")
TrafficPattern.create(name: "Multiple Lane Closures", description: "More than one lane has been closed")
TrafficPattern.create(name: "Road Closure", description: "The road has been closed to traffic in both directions, indefintely")
TrafficPattern.create(name: "Drive carefully", description: "Road conditions require special driver attention")
TrafficPattern.create(name: "Single lane alternating", description: "One lane open to alternating directions of traffic")
TrafficPattern.create(name: "Delay longer than 10 minutes", description: "Delay longer than the indicated minutes but not as long as next interval of minutes.")
TrafficPattern.create(name: "Delay longer than 20 minutes", description: "Delay longer than the indicated minutes but not as long as next interval of minutes.")
TrafficPattern.create(name: "Delay longer than 30 minutes", description: "Delay longer than the indicated minutes but not as long as next interval of minutes.")
TrafficPattern.create(name: "Delay longer than 40 minutes", description: "Delay longer than the indicated minutes but not as long as next interval of minutes.")
TrafficPattern.create(name: "Delay longer than 50 minutes", description: "Delay longer than the indicated minutes but not as long as next interval of minutes.")
TrafficPattern.create(name: "Delay longer than 1 hour", description: "Delay longer than one hour.")

Direction.create(name: "North", description: "Northbound")
Direction.create(name: "East", description: "Eastbound")
Direction.create(name: "South", description: "Southbound")
Direction.create(name: "West", description: "Westbound")
Direction.create(name: "Both", description: "Both directions")
Direction.create(name: "All", description: "All directions")

SpatialType.create(name: "Point")
SpatialType.create(name: "Polygon")
SpatialType.create(name: "Multi-Point")
SpatialType.create(name: "Multi-Polygon")

Status.create(name: "Edit", description: "Editing event, not ready for review")
Status.create(name: "Review", description: "Ready to be reiviewed before publishing")
Status.create(name: "Publish", description: "Publish for public viewing")
Status.create(name: "Reported", description: "Crowd-sourced information that is unverified.")

Role.create(:name => "admin", :description => "Super user administrator.")
Role.create(:name => "owner", :description => "Can edit their owner account, events and set any status.")
Role.create(:name => "reviewer", :description => "Can edit their events and publish.")
Role.create(:name => "dataentry", :description => "Can edit their events.")

Owner.create(:name => "public", :description => "DriveWhere publically sourced data uses this owner account.", :contact_first => "John", :contact_last => "Doe", :address_1 => "-", :address_2 => "", :city => "", :region => "", :country => "Canada", :postal => "", :phone => "", :email => "public@none.abc", :created_by => "default")

User.create(:name => "admin", :password => "administrator", :expiry => 1.year.from_now , :active => true, :owner_id => nil, :role_id => 1, :first_name => "James", :last_name => "Bond", :phone => "007", :email => "jbond@mi5.gov.uk", :created_by => "default")
User.create(:name => "public", :password => "public12", :expiry => 100.year.from_now , :active => true, :owner_id => 1, :role_id => 4, :first_name => "John", :last_name => "Doe", :phone => "", :email => "", :created_by => "default")

District.create(name: "Unknown", created_by: "default")

# ==============================================================
# For development, sample data and owner preferences.
# ==============================================================
Owner.create(:name => "Ministry of Magic", :description => "Fantasy agency in magic and make believe!", :contact_first => "Harry", :contact_last => "Potter",	:address_1 => "Hogwarts School", :address_2 => "Administration Dept.", :city => "Hagishimwagn", :region => "Glandafer", :country => "England",	:postal => "M1A K2B", :phone => "2434234234", :email => "hpotter@hogwarts.edu", :created_by => "jkrowling")
Owner.create(:name => "The Empire", :description => "Ruler of the universe and everthing in it.", :contact_first => "Darth", :contact_last => "Vader",	:address_1 => "Death Star", :address_2 => "Penthouse", :city => "Moon", :region => "Alderon System", :country => "Tatu",	:postal => "666 666", :phone => "9387463892", :email => "dvader@deathstart.org", :created_by => "jlucas")

User.create(:name => "MinistryOfMagic", :password => "MinistryOfMagic", :expiry => Time.now , :active => true, :owner_id => 2, :role_id => 2, :first_name => "Daniel", :last_name => "Ratcliff", :phone => "43422434324", :email => "dratcliff@hogwarts.edu", :created_by => "admin")
User.create(:name => "TheEmpire", :password => "TheEmpire", :expiry => Time.now , :active => true, :owner_id => 2, :role_id => 3, :first_name => "Lord", :last_name => "Emporer", :phone => "3924039276", :email => "darklord@deathstar.org", :created_by => "admin")
User.create(:name => "dvader", :password => "dvader01", :expiry => Time.now , :active => true, :owner_id => 2, :role_id => 3, :first_name => "Darth", :last_name => "Vader", :phone => "9182474162", :email => "dvader@deathstar.org", :created_by => "admin")

District.create(name: "Maltazen", created_by: "jkrowling")
District.create(name: "Okendar", created_by: "jlucas")

OwnerEventType.create(:owner_id => 1, :event_type_id => 1, :created_by => "jkrowling")
OwnerEventType.create(:owner_id => 1, :event_type_id => 2, :created_by => "jkrowling")
OwnerEventType.create(:owner_id => 1, :event_type_id => 3, :created_by => "jkrowling")
OwnerEventType.create(:owner_id => 2, :event_type_id => 1, :created_by => "jlucas")
OwnerEventType.create(:owner_id => 2, :event_type_id => 2, :created_by => "jlucas")

OwnerSeverity.create(:owner_id => 1, :severity_id => 1)
OwnerSeverity.create(:owner_id => 1, :severity_id => 2)
OwnerSeverity.create(:owner_id => 1, :severity_id => 3)
OwnerSeverity.create(:owner_id => 2, :severity_id => 2)
OwnerSeverity.create(:owner_id => 2, :severity_id => 3)

OwnerDistrict.create(:owner_id => 1, :district_id => 1, :created_by => "jkrowling")
OwnerDistrict.create(:owner_id => 2, :district_id => 2, :created_by => "jlucas")

OwnerTrafficPattern.create(:owner_id => 1, :traffic_pattern_id => 1)
OwnerTrafficPattern.create(:owner_id => 1, :traffic_pattern_id => 2)
OwnerTrafficPattern.create(:owner_id => 1, :traffic_pattern_id => 3)
OwnerTrafficPattern.create(:owner_id => 1, :traffic_pattern_id => 4)
OwnerTrafficPattern.create(:owner_id => 1, :traffic_pattern_id => 5)
OwnerTrafficPattern.create(:owner_id => 1, :traffic_pattern_id => 6)
OwnerTrafficPattern.create(:owner_id => 1, :traffic_pattern_id => 7)
OwnerTrafficPattern.create(:owner_id => 1, :traffic_pattern_id => 8)
OwnerTrafficPattern.create(:owner_id => 1, :traffic_pattern_id => 9)
OwnerTrafficPattern.create(:owner_id => 1, :traffic_pattern_id => 10)
OwnerTrafficPattern.create(:owner_id => 1, :traffic_pattern_id => 11)
OwnerTrafficPattern.create(:owner_id => 1, :traffic_pattern_id => 12)
OwnerTrafficPattern.create(:owner_id => 2, :traffic_pattern_id => 1)
OwnerTrafficPattern.create(:owner_id => 2, :traffic_pattern_id => 2)
OwnerTrafficPattern.create(:owner_id => 2, :traffic_pattern_id => 3)
OwnerTrafficPattern.create(:owner_id => 2, :traffic_pattern_id => 4)
OwnerTrafficPattern.create(:owner_id => 2, :traffic_pattern_id => 5)
OwnerTrafficPattern.create(:owner_id => 2, :traffic_pattern_id => 6)
OwnerTrafficPattern.create(:owner_id => 2, :traffic_pattern_id => 7)
OwnerTrafficPattern.create(:owner_id => 2, :traffic_pattern_id => 8)

OwnerStatus.create(:owner_id => 1, :status_id => 1)
OwnerStatus.create(:owner_id => 1, :status_id => 2)
OwnerStatus.create(:owner_id => 1, :status_id => 3)
OwnerStatus.create(:owner_id => 2, :status_id => 1)
OwnerStatus.create(:owner_id => 2, :status_id => 2)
OwnerStatus.create(:owner_id => 2, :status_id => 3)

#factory = Location.rgeo_factory_for_column(:geom)
#Location.create(:geom => factory.collection([factory.point(-122.79273772239685, 49.04487974750465)]), :created_by => "jkrowling")
#Location.create(:geom => factory.collection([factory.point(-122.20872587841802, 49.07978759807272)]), :created_by => "jlucas")
#Location.create(:geom => factory.collection([factory.point(-123.38937800377607, 48.537572212952185)]), :created_by => "public")
# These records use float columns for lat/lon values and not a geometry column as above.
Location.create(:latitude => 49.04487974750465, :longitude => -122.79273772239685, :created_by => "jkrowling")
Location.create(:latitude => 49.07978759807272, :longitude => -122.20872587841802, :created_by => "jlucas")
Location.create(:latitude => 48.537572212952185, :longitude => -123.38937800377607, :created_by => "public")

Event.create(:road => "Hwy 1", :district_id => 2, :direction_id => 1, :event_type_id => 1, :severity_id => 2, :traffic_pattern_id => 7, :start_date => 42.hours.ago, :title => "Cart blocking roadway", :description => "A cart full of magic pumpkins lost a wheel and spread everything all over the road making a bloody mess of things.", :owner_id => 2, :status_id => 2, :location_id => 1, :created_by => "jkrowling")
Event.create(:road => "Hwy 2", :district_id => 3, :direction_id => 1, :event_type_id => 2, :severity_id => 3, :traffic_pattern_id => 3, :start_date => 34.hour.ago, :title => "Dragon fire", :description => "A dragon has caused the village to be on fire.", :owner_id => 3, :status_id => 3, :location_id => 2, :created_by => "jlucas")
Event.create(:road => "Pat Bay Hwy", :district_id => 1, :direction_id => 4, :event_type_id => 3, :severity_id => 3, :traffic_pattern_id => 2, :start_date => 1.hour.ago, :title => "Head-on collision", :description => "A car ran a red light at the Elk Lake intersection and hit another car heading south.", :owner_id => 1, :status_id => 4, :location_id => 3, :created_by => "public")