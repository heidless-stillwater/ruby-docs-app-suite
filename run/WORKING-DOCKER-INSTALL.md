# INSTALL

```
sudo chmod 666 /var/run/docker.sock

sudo apt install net-tools
ipconfig /flushdns

#########################
Dockerfile
# ENV RAILS_ENV=production
ENV RAILS_ENV=development

# bundle config set --local without 'development test' && \
bundle config set --local && \

#########################

cd run

RAILS_ENV='development'
echo $RAILS_ENV

docker build -f Dockerfile -t hellorails .

docker run -p 3000:3000 -v $(pwd):/rails hellorails

--

gcloud init
--
heidless-ror-0
heidlessemail05.gmail.com

--

gcloud builds submit --tag gcr.io/heidless-ror-0/alpha-blog-0

```
