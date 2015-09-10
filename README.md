
# DriveWhere

A prototype website created with Ruby on Rails.

There are two parts to this website.  The public side with a map, list of events and a crowd-sourcing reporting interface, and the administration side with screens to configure not only users and their access, but settings on a per-client basis for all values related to events such as types, directions, etc.

The administration interface requires a user/password to access.

## Notes

Other useful documents can be found in the 'docs' directory.

DriveWhere application - Phase 1 version
	-Database data is only in English in this version.  
		-Multiple languages should be planned for in future versions.

* Ruby version:
	-Written using version 2.0.0p481

* System dependencies:
    -Install ruby DevTools package from http://rubyinstaller.org/downloads
	-Postgres and PostGIS plugin:
		gems: pg, rgeo, activerecord-postgis-adapter
	-Deployment to Heroku required that we not use sptaial PostGIS so you can skip this part.

* Configuration:
	-See contents of /docs/postgres_setup_notes.txt
	-For Heroku, no spatial database is used so skip PostGIS.

* Database creation:
	-An existing 'drivewhere' postgres server connection.
	-All tables are created via this applications schema file using rake utility.
	-See contents of /docs/postgres_setup_notes.txt for more information.

* Database initialization:
	-Use rake command from root of this application to create the required tables:
		rake db:schema:load
	-Migrate anything that might not be included in the schema:
		rake db:migrate
	-Populate code lookup tables with seed data:
		rake db:seed
	 Note: Do not seed database if it already has data since it will duplicate data already there.

* How to run the test suite
	-Not yet used.

* Services (job queues, cache servers, search engines, etc.)
	-Not yet used.

* Deployment instructions
	-Heroku deployment instructions in /docs/Heroku Deployment.txt