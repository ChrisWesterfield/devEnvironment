#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
echo "nameserver 8.8.8.8" | sudo tee --append /etc/resolv.conf
sudo apt-get update
sudo apt-get clean
sudo apt-get -y autoremove
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade