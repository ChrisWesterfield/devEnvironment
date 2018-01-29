#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.cockpit ]
then
    echo "Cockpit already installed."
    exit 0
fi

touch /home/vagrant/.cockpit
sudo add-apt-repository ppa:cockpit-project/cockpit -y
sudo echo "deb http://ppa.launchpad.net/cockpit-project/cockpit/ubuntu xenial main" > /etc/apt/sources.list.d/cockpit-project-ubuntu-cockpit-yakkety.list
sudo apt-get update
sudo apt-get install cockpit -y
sudo apt-get install cockpit-bridge cockpit-docker cockpit-ws  cockpit-system -y
