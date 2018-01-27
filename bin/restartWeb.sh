#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
sudo /usr/bin/env service nginx restart
source /vagrant/bin/restartPhp.sh
