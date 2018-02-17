#!/usr/bin/env bash

if [ -f /home/vagrant/.phpma ]
then
    echo "PHP MongoDb Admin already installed."
    exit 0
fi
touch /home/vagrant/.phpma
cd /home/vagrant
git clone https://github.com/jwage/php-mongodb-admin.git phpma
cd phpma
ln mongodbadmin.php index.php
