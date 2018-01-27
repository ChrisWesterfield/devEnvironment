#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.ant ]
then
    echo "ANT already installed."
    exit 0
fi

touch /home/vagrant/.ant

sudo apt-get install ant -y