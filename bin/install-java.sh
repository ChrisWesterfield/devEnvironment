#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.java ]
then
    echo "Java already installed."
    exit 0
fi

touch /home/vagrant/.java

sudo apt-get install openjdk-8-jre-headless openjdk-8-jdk-headless -y