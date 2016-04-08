#!/bin/bash

cd /vagrant
npm install
bundle install
cp config/database.example.yml config/database.yml
sudo apt-get -y install phantomjs
sudo apt-get -y remove phantomjs
sudo npm install -g phantomjs
rake db:create
rake db:migrate
