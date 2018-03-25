#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.sqlite ]
then
    echo "SQLITE already installed."
    exit 0
fi

touch /home/vagrant/.sqlite
sudo apt-get install -y sqlite3 libsqlite3-dev