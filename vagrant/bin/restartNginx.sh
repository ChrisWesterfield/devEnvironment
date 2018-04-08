#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.apps/nginx ]
then
    sudo /usr/bin/env service nginx restart
fi
if [ -f /home/vagrant/..apps/apache2 ]
then
    sudo /usr/bin/env service apache2 restart
fi
if [ -f /home/vagrant/..apps/apache ]
then
    sudo /usr/bin/env service apache2 restart
fi
