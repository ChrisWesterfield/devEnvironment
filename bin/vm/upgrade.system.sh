#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get clean
sudo apt-get -y autoremove
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade