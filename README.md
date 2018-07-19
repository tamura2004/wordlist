# Installation

## Requirements:

- ruby 2.3+
- yarn
- postgresql

## Getting Started:

- Ubuntu 18.04 LTS 

```
$ cd
$ pwd
/home/ubuntu/

$ mkdir run

$ cat /etc/issue
Ubuntu 18.04 LTS

$ git clone https://github.com/tamura2004/vue_handsontable.git workplan
$ cd workplan
$ sudo apt-get update
$ sudo apt-get install -y --no-install-recommends ruby ruby-dev
$ ruby -v
ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux-gnu]

$ gem -v
2.7.6

$ sudo gem install bundler
$ bundle -v
Bundler version 1.16.2

$ sudo apt-get install -y --no-install-recommends npm nodejs
$ nodejs -v
v8.10.0

$ npm -v
3.5.2

$ sudo npm cache clean
$ sudo npm install n -g
$ sudo n stable
$ sudo ln -sf /usr/local/bin/node /usr/bin/node
$ node -v
v10.2.1
$ sudo apt-get purge -y nodejs npm

$ sudo apt-get install -y --no-install-recommends libgdbm-dev build-essential postgresql libpq-dev
$ psql --version
psql (PostgreSQL) 10.3 (Ubuntu 10.4-0ubuntu0.18.04)

$ pg_dump --version
pg_dump (PostgreSQL) 10.3 (Ubuntu 10.4-0ubuntu0.18.04)

$ sudo apt-get install zlib1g-dev
$ bundle install --without test development --path vendor/bundle

$ sudo su - postgres
$ psql
$ create user tamura with password 'tamura' createdb;

$ vim /etc/postgresql/10/main/postgresql.conf
shared_buffers = 1600MB
temp_buffers = 32MB
work_mem = 32MB
maintenance_work_mem = 128MB
wal_buffers = 16MB

$ sudo service postgresql restart

$ RAILS_ENV=production bundle exec rails db:create
$ RAILS_ENV=production bundle exec rails db:migrate
$ DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production bundle exec rails db:reset

$ scp -i key seeds.sql ubuntu@workplan.sofia3dd.net:~/workplan/tmp/seeds.sql

$ RAILS_ENV=production bundle exec rails db:seed

$ rails -v
Rails 5.0.7

$ curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
$ echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
$ sudo apt-get update
$ sudo apt-get install -y --no-install-recommends yarn
$ yarn --version
1.7.0

$ yarn
$ RAILS_ENV=production rails assets:precompile

$ sudo apt-get install nginx
$ nginx -v
nginx version: nginx/1.14.0 (Ubuntu)

$ sudo rm /etc/nginx/sites-enabled/default
$ sudo ln -sf  /home/ubuntu/workplan/nginx.conf /etc/nginx/conf.d/nginx.conf
$ sudo nginx -s reload

$ sudo cp /home/ubuntu/workplan/puma.service /etc/systemd/system/puma.service
$ sudo systemctl daemon-reload
$ sudo systemctl enable puma.service
$ sudo systemctl start puma.service
$ sudo systemctl status puma.service

```

