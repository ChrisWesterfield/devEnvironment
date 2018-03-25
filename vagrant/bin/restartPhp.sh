#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.php72 ]
then
    sudo /usr/bin/env service php7.2-fpm restart
fi
if [ -f /home/vagrant/.php71 ]
then
    sudo /usr/bin/env service php7.1-fpm restart
fi
if [ -f /home/vagrant/.php70 ]
then
    sudo /usr/bin/env service php7.0-fpm restart
fi
if [ -f /home/vagrant/.php56 ]
then
    sudo /usr/bin/env service php5.6-fpm restart
fi
if [ -f /home/vagrant/.hhvm ]
then
    sudo /usr/bin/env service hhvm restart
fi