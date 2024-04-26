

# Utils

- ## [Fix Rails Blocked Host Error with Docker](https://danielabaron.me/blog/rails-blocked-host-docker-fix/)

- ## [production ready rails/docker - docker-rails-example](https://github.com/nickjj/docker-rails-example)

- ## [Running Rails on Google Cloud](https://cloud.google.com/ruby/rails)
    - ### [Running Rails on the Cloud Run environment ](https://cloud.google.com/ruby/rails/run)
    - ### - [Quickstart: Deploy a Ruby service to Cloud Run](https://cloud.google.com/run/docs/quickstarts/build-and-deploy/deploy-ruby-service)


# [Running Rails on the Cloud Run environment ](https://cloud.google.com/ruby/rails/run)

### Cloning the Rails app
```
#git clone https://github.com/GoogleCloudPlatform/ruby-docs-samples.git

#cd ruby-docs-samples/run/rails

git clone https://github.com/heidless-stillwater/rails-cat-album-gcloud-deploy.git

cd rails-cat-album-gcloud-deploy/run/rails

cd gcloud-run-ruby-proto/run/cat-photo-album

bundle install
```


## Generate RAILS_MASTER_KEY - If REQUESTED
```
# refreshes 'config/master.key' & 'config/credentials.enc' 
EDITOR='subl --wait' ./bin/rails credentials:edit
```

## dotenv environment
### [Setting up Dotenv in Rails](https://onlyoneaman.medium.com/setting-up-dotenv-in-rails-a8ce1c69e03d)
```
# initialise .env
touch .env

```

################################################################################################
################################## setup & deploy app ##########################################
################################################################################################

## create SQL instance

### [instances](https://console.cloud.google.com/sql/instances?project=heidless-pfolio-deploy-5)

## USEFUL IF NEEDED
```
# enable/disable deletion protection
gcloud sql instances patch cat-photo-album-0 \
    --deletion-protection

```

## prep OS
```
<!-- cd ./run/cat-photo-album
yarnpkg add -W caniuse-lite
sudo npm install -g n
sudo n latest
npx update-browserslist-db@latest
sudo apt install apt-utils -->


# prep OS
sudo apt install apt-utils
```

# initialise app
gcloud init

# setup APP_name
```

export APP_NAME=cat-photo-album
#export APP_NAME=alpha-blog

export PROJECT_NAME=heidless-ror-0
export SERVICE_NAME=$APP_NAME-svc

export POSTGRES_VERSION=POSTGRES_14
export REGION=europe-west2
export TIER=db-f1-micro
export INSTANCE_NAME=$APP_NAME-instance-0
export DB_NAME=$APP_NAME-db-0
export USER_NAME=$APP_NAME-user-0

export BUCKET_NAME=$PROJECT_NAME-$APP_NAME-bucket-0
export SECRET_NAME=$APP_NAME-secret-0

gcloud projects describe $PROJECT_NAME --format='value(projectNumber)'
---
export PROJECT_ID=572438747266

---



# build sample service to generate username
Cloud Run->Create Service->Select-#.Demo containers->hello
--
export USER_SERVICE=572438747266-compute@developer.gserviceaccount.com
--

```

# Database

### [gcp: Create a DATABASE](https://console.cloud.google.com/sql/instances/blog-demo-instance-1/databases?project=heidless-pfolio-deploy-5)

```
gcloud sql instances create $INSTANCE_NAME \
    --database-version $POSTGRES_VERSION \
    --tier db-f1-micro \
    --region $REGION

```

```
gcloud sql databases create $DB_NAME \
    --instance $INSTANCE_NAME

```

### gcp: password

### create USER
### [gcp: create user](https://console.cloud.google.com/sql/instances/blog-demo-instance-1/users?project=heidless-pfolio-deploy-5)
```
# generate password to 'dbpassword'.
# in PRODUCTION USE 'dbpassword'. 

cat /dev/urandom | LC_ALL=C tr -dc '[:alpha:]'| fold -w 50 | head -n1 > dbpassword

---
gcloud sql users create $USER_NAME \
   --instance=$INSTANCE_NAME --password=$(cat dbpassword)

```
### Set up a Cloud Storage bucket
### [storage bucket](https://console.cloud.google.com/storage/browser?referrer=search&project=heidless-pfolio-deploy-5&prefix=&forceOnBucketsSortingFiltering=true)

```
gsutil mb -l europe-west2 gs://$BUCKET_NAME

```

### [bucket permissions]()
```
gsutil iam ch allUsers:objectViewer gs://$BUCKET_NAME

```

## Secret Mgr
### Create encrypted credentials file and store key as Secret Manager secret

```
# utils
gcloud secrets delete $SECRET_NAME
```

### install sublime - IF NEEDED
```
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt-get update
```

### ubuntu window - if NEEDED
```
sudo apt-get install sublime-text
```

### setup gcp:credentials
### sets up encryped crtedentials for use in live

```
# make sure to delete previous config/credentials.yml.enc
rm config/credentials.yml.enc config/master.key
---
# get password from './dbpassword'
IpbXXpOEFNOcFpDQOFglMrFNUhkjUIoxENJxBCERUTUmWYuOvp
---
# password value in file config/credentials.yml.enc
EDITOR='subl --wait' ./bin/rails credentials:edit

---
# potentially setup other definitions: 
#   db_name_production
#   cloud_sql_connection_name
#   google_project_id
#   storage_bucket_id
---
secret_key_base: GENERATED_VALUE
gcp:
  db_password: IpbXXpOEFNOcFpDQOFglMrFNUhkjUIoxENJxBCERUTUmWYuOvp
```

```
# utils - IF NEEDED
gcloud secrets delete $SECRET_NAME
```

### create gcp:secret
```
gcloud secrets create $SECRET_NAME --data-file config/master.key

```

### describe Secret
```
gcloud secrets describe $SECRET_NAME

gcloud secrets versions access latest --secret $SECRET_NAME
---
fdf07513d99a2d08645896b14651fcdc%%    

```

### setup gcp: secret access permissions

## COMPUTE access to secrets
```


# CLOUD COMPUTE access to secrets
gcloud secrets add-iam-policy-binding $SECRET_NAME \
    --member serviceAccount:$PROJECT_ID-compute@developer.gserviceaccount.com \
    --role roles/secretmanager.secretAccessor

## CLOUD BUILD access to secrets
gcloud secrets add-iam-policy-binding cat-photo-album-secret-0 \
    --member serviceAccount:$PROJECT_ID@cloudbuild.gserviceaccount.com \
    --role roles/secretmanager.secretAccessor

```

## Connect Rails app to production database and storage
### .env
```
cd PROJECT_ROOT
touch .env
---
echo "PRODUCTION_DB_NAME: $DB_NAME" > .env
echo "PRODUCTION_DB_USERNAME: $USER_NAME" >> .env
echo "CLOUD_SQL_CONNECTION_NAME: $PROJECT_NAME:$REGION:$INSTANCE_NAME" >> .env
echo "GOOGLE_PROJECT_ID: $PROJECT_NAME" >> .env
echo "STORAGE_BUCKET_NAME: $BUCKET_NAME" >> .env

```

### Grant Cloud Build access to Cloud SQL
```
gcloud projects add-iam-policy-binding $PROJECT_NAME \
    --member serviceAccount:$PROJECT_ID@cloudbuild.gserviceaccount.com \
    --role roles/cloudsql.client

```

# Deploying the app to Cloud Run

```
echo $SERVICE_NAME
echo $INSTANCE_NAME
echo $REGION
echo $SECRET_NAME

gcloud builds submit --config cloudbuild.yaml \
    --substitutions _SERVICE_NAME=cat-photo-album-svc,_INSTANCE_NAME=cat-photo-album-instance-0,_REGION=europe-west2,_SECRET_NAME=cat-photo-album-secret-0


gcloud builds submit --config cloudbuild.yaml \
    --substitutions _SERVICE_NAME=$SERVICE_NAME,_INSTANCE_NAME=$INSTANCE_NAME,_REGION=$REGION,_SECRET_NAME=$SECRET_NAME

---

gcloud run deploy cat-photo-album-svc \
     --platform managed \
     --region europe-west2 \
     --image gcr.io/heidless-pfolio-deploy-5/cat-photo-album-svc \
     --image gcr.io/heidless-pfolio-deploy-5/cat-photo-album-svc \
     --add-cloudsql-instances heidless-pfolio-deploy-5:europe-west2:cat-photo-album-instance-0 \
     --allow-unauthenticated

gcloud run deploy $SERVICE_NAME \
     --platform managed \
     --region $REGION \
     --image gcr.io/$PROJECT_NAME/$SERVICE_NAME \
     --add-cloudsql-instances $PROJECT_NAME:$REGION:$INSTANCE_NAME \
     --allow-unauthenticated

gcloud run deploy cat-photo-album-svc \
     --platform managed \
     --region europe-west2 \
     --image gcr.io/heidless-pfolio-deploy-5/cat-photo-album-svc \
     --add-cloudsql-instances heidless-pfolio-deploy-5:europe-west2:cat-photo-album-instance-0 \
     --allow-unauthenticated

---

Service [cat-album-svc] revision [cat-album-svc-00001-mh6] has been deployed and is serving 100 percent of traffic.

Service URL: https://cat-album-svc-pvqvpcgdcq-nw.a.run.app

```

