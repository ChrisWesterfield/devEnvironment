#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ ! -f /home/vagrant/.xhgui ]
then
    echo "XHGUI already configured"
    exit 0
fi

touch /home/vagrant/.xhgui
