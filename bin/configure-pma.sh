#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.pma ]
then
    echo "PHPMyAdmin already configured"
    exit 0
fi
touch /home/vagrant/.pma
