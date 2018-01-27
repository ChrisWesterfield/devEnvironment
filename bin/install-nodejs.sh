#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.nodejs ]
then
    echo "NodeJS already installed."
    exit 0
fi
touch /home/vagrant/.nodejs
sudo apt-get remove nodejs npm -y
sudo apt-get install curl -y
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install build-essential   -y