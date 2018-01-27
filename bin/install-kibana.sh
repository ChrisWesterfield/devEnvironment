#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.kibana ]
then
    echo "Kibana already installed."
    exit 0
fi
touch /home/vagrant/.kibana

cd /home/vagrant
sudo curl https://artifacts.elastic.co/downloads/kibana/kibana-6.1.1-amd64.deb > kibana.deb
sudo dpkg -i /home/vagrant/kibana.deb
sudo rm /home/vagrant/kibana.deb
sudo systemctl enable kibana
sudo systemctl restart kibana