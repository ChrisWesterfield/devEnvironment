#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
# Check If Maria Has Been Installed

if [ -f /home/vagrant/.redis ]
then
    echo "Redis already installed."
    exit 0
fi

touch /home/vagrant/.redis

sudo apt-get install redis-server php-redis -y