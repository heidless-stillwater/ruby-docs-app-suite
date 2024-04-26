
## [Make the move from Sqlite3 to Postgres in Rails 6](https://dev.to/forksofpower/make-the-move-from-sqlite3-to-postgres-in-rails-6-34m2)

# install

[Step-by-Step Process to Uninstall PostgreSQL on Ubuntu](https://www.squash.io/step-by-step-process-to-uninstall-postgresql-on-ubuntu/)

[Creating user, database and adding access on PostgreSQL](https://medium.com/coding-blocks/creating-user-database-and-adding-access-on-postgresql-8bfcd2f4a91e)

```

################
# fully remove postgres - if DESIRED!
sudo su postgres
psql -V
--
psql (PostgreSQL) 14.11 (Ubuntu 14.11-0ubuntu0.22.04.1)
--
sudo apt-get remove --purge postgresql-14
################

# install
sudo apt-get install postgresql

# restart
sudo service postgresql restart

# admin login - 'postgres'
sudo su postgres
psql

# add postgres password
# ALTER USER postgres PASSWORD 'postgres';

--
CREATE DATABASE alpha_blog_development;
CREATE DATABASE alpha_blog_production;
CREATE DATABASE alpha_blog_test;
CREATE USER heidless WITH SUPERUSER PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE alpha_blog_development to heidless;
GRANT ALL PRIVILEGES ON DATABASE alpha_blog_production to heidless;
GRANT ALL PRIVILEGES ON DATABASE alpha_blog_test to heidless;
--


### RUBY comfig

bundle remove sqlite3

#gem install pg

bundle add pg

# If you have any columns of the type t.string in your migrations, 
# it is highly recommended that you replace that type with t.text.

rails db:setup

rails s

```
### setup .env
```
# development
export DATABASE_USERNAME="alpha_blog_admin"
export DATABASE_PASSWORD="password"
export SOCKET="/var/run/postgresql/.s.PGSQL.5432"
export DEVELOPMENT_DATABASE="alpha_blog_development"
export PRODUCTION_DATABASE="alpha_blog_production"

# gCloud
PRODUCTION_DB_NAME: alpha-blog-db-0
PRODUCTION_DB_USERNAME: alpha-blog-user-0
CLOUD_SQL_CONNECTION_NAME: heidless-pfolio-deploy-5:europe-west2:alpha-blog-instance-0
GOOGLE_PROJECT_ID: heidless-pfolio-deploy-5
STORAGE_BUCKET_NAME: heidless-pfolio-deploy-5-alpha-blog-bucket-0

# validate the settings
erb ./config/database.yml

```

############ update config/database.yml
```
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see Rails configuration guide
  # https://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: alpha_blog_development

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: alpha_blog_test

production:
  <<: *default
  database: alpha_blog_production
  username: pixel_place
  password: <%= ENV['PIXEL_PLACE_DATABASE_PASSWORD'] %>
  
```






# restart postrgres
sudo service postgresql restart

```
sudo su postgres
psql 

\password postgres
--
postgres
--

sudo -u postgres createuser --superuser $USER


```

# create admin user & db
```
CREATE USER admin WITH SUPERUSER PASSWORD 'Maver1ck1965';

CREATE USER alpha_blog_admin WITH SUPERUSER PASSWORD 'password';

CREATES DATABASE alpha_blog_admin


```

psql -d admin -U admin

psql -d alpha_blog_admin -U alpha_blog_admin

# create application user
```
CREATE USER heidless WITH PASSWORD 'Havana11';

```

# APPLICATION: DB 
```
CREATE DATABASE alpha-blog-db

```

# pgadmin
```
http://localhost/pgadmin4/browser/
---
rob.lockhart@yahoo.co.uk
havana11
---
```



# new user


# new db







