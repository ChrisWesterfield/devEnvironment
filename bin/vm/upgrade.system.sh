#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
echo "nameserver 8.8.8.8" | tee --append /etc/resolv.conf
apt-get update
apt-get clean
apt-get -y autoremove
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade