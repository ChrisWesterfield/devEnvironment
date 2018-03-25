#!/usr/bin/env bash
if [ -f /home/vagrant/.netdata ]
then
    echo "NetData already installed."
    exit 0
fi

touch /home/vagrant/.netdata
bash <(curl -Ss https://my-netdata.io/kickstart.sh) --non-interactive all