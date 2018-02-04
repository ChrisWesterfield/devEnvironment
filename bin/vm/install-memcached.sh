#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
# Check If Maria Has Been Installed

if [ -f /home/vagrant/.memcached ]
then
    echo "Memcached already installed."
    exit 0
fi

touch /home/vagrant/.memcached

sudo apt-get install memcached php-memcached php7.0-dev php5.6-dev php7.1-dev php7.2-dev -y

cd /usr/src

git clone https://github.com/websupport-sk/pecl-memcache.git php-memcached
cd php-memcached
git checkout php7

if [ -f /home/vagrant/.php72 ]
then
    apt-get install php7.2-dev php7.2-memcache -y
    make clean
    git reset --hard HEAD
    rm .deps config.h.in~ configure.ac -y
    phpize7.2
    ./configure
    make
    sudo make install
    ln -s /vagrant/etc/php/memcached.ini /etc/php/7.2/cli/conf.d/30-memcached.ini
    ln -s /vagrant/etc/php/memcached.ini /etc/php/7.2/fpm/conf.d/30-memcached.ini
    ln -s /usr/lib/php/20170718/memcached.so /usr/lib/php/20170718/memcached.so.so
fi

if [ -f /home/vagrant/.php71 ]
then
    apt-get install php7.1-dev php7.1-memcache -y
    make clean
    git reset --hard HEAD
    rm .deps config.h.in~ configure.ac -y
    phpize7.1
    ./configure
    make
    sudo make install
    ln -s /vagrant/etc/php/memcached.ini /etc/php/7.1/cli/conf.d/30-memcached.ini
    ln -s /vagrant/etc/php/memcached.ini /etc/php/7.1/fpm/conf.d/30-memcached.ini
fi

if [ -f /home/vagrant/.php70 ]
then
    apt-get install php7.0-dev php7.0-memcache -y
    make clean
    git reset --hard HEAD
    rm .deps config.h.in~ configure.ac -y
    phpize7.0
    ./configure
    make
    sudo make install
    ln -s /vagrant/etc/php/memcached.ini /etc/php/7.0/cli/conf.d/30-memcached.ini
    ln -s /vagrant/etc/php/memcached.ini /etc/php/7.0/fpm/conf.d/30-memcached.ini
fi

if [ -f /home/vagrant/.php72 ] || [ -f /home/vagrant/.php71 ] || [ -f /home/vagrant/.php70 ]
then
    rm /etc/php/7.*/*/conf.d/25-memcached.ini
fi


if [ -f /home/vagrant/.php56 ]
then
    sudo apt-get install php5.6-memcached php5.6-memcache    -y
fi

source /vagrant/bin/restartPhp.sh