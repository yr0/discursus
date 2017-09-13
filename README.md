# Discursus
Source code for the website.

## Installation without Vagrant box
1. Install rvm and ruby 2.3.1
0. Install PostgreSQL 9.5
0. Install Solr 6.3 (latest at the time of writing), create a new core, and specify path to it 
    in *config/solr.yml*. Copy sunspot config files *schema.xml* and *solrconfig.xml* from config/sunspot 
    and place them in /var/solr/data/<collection_name>/conf. Restart the solr service afterwards. 
0. `cd` into app directory and run `bundle` to install the dependencies
0. Create *.env* file in directory root and populate it with the following data:

        DB_USER=<database_user>
        DB_PASS=<database_password>
        DEFAULT_ADMIN_EMAIL=<email for auto-generated administrator>
        DEFAULT_ADMIN_PASS=<password for auto-generated admininstrator>
        GMAPS_API_KEY=<API key for Gmaps within application>
    
0. After configuring database access in *config/database.yml*, run `rails db:create db:schema:load db:seed`. This will
    create database, set up the existing schema in it, and seed the administrator user with any other required data.
    
## Installation with Vagrant
0. Make sure you have Vagrant Ansible, and nfsd installed. 
0. Run `vagrant up`
0. Run `vagrant ssh` to log into the box.

## Developing/starting
0. To run tests, use `rspec`
0. To start the server, run `rails s`
