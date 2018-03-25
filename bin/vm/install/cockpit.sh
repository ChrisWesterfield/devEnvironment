#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.cockpit ]
then
    echo "Cockpit already installed."
    exit 0
fi

touch /home/vagrant/.cockpit
add-apt-repository ppa:cockpit-project/cockpit -y
echo "deb http://ppa.launchpad.net/cockpit-project/cockpit/ubuntu xenial main" > /etc/apt/sources.list.d/cockpit-project-ubuntu-cockpit-yakkety.list
apt-get update
apt-get install cockpit -y
apt-get install cockpit-bridge cockpit-ws  cockpit-system -y

service cockpit restart