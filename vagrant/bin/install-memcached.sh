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

git clone https://github.com/php-memcached-dev/php-memcached.git
cd php-memcached
git checkout php7


make clean
phpize7.0
./configure --disable-memcached-sasl
make
sudo make install

make clean
phpize7.1
./configure --disable-memcached-sasl
make
sudo make install

make clean
phpize7.2
./configure --disable-memcached-sasl
make
sudo make install

ln -s /vagrant/etc/php/memcached.ini /etc/php/7.0/cli/conf.d/20-memcached.ini
ln -s /vagrant/etc/php/memcached.ini /etc/php/7.0/fpm/conf.d/20-memcached.ini
ln -s /vagrant/etc/php/memcached.ini /etc/php/7.1/cli/conf.d/20-memcached.ini
ln -s /vagrant/etc/php/memcached.ini /etc/php/7.1/fpm/conf.d/20-memcached.ini
ln -s /vagrant/etc/php/memcached.ini /etc/php/7.2/cli/conf.d/20-memcached.ini
ln -s /vagrant/etc/php/memcached.ini /etc/php/7.2/fpm/conf.d/20-memcached.ini

sudo apt-get install php5.6-memcached php5.6-memcache php7.0-memcache php7.1-memcache php7.2-memcache -y

source /vagrant/bin/restartPhp.sh