#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.nginx ]
then
    sudo /usr/bin/env service nginx restart
fi
if [ -f /home/vagrant/.apache2 ]
then
    sudo /usr/bin/env service apache2 restart
fi
source /vagrant/bin/restartPhp.sh
