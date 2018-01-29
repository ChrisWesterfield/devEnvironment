#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive


if [ -f /home/vagrant/.blackfire ]
then
    echo "NGINX already installed."
    exit 0
fi
touch /home/vagrant/.blackfire

curl -s https://packagecloud.io/gpg.key | apt-key add -
echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list


apt-get install -y blackfire-agent blackfire-php