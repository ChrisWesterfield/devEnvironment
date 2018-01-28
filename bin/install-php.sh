#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.php ]
then
    echo "PHP already installed."
    exit 0
fi
touch /home/vagrant/.php
sudo apt-get install -y  php7.0-fpm php7.1-fpm php7.2-fpm php-yaml php-xdebug

cd /usr/src
sudo git clone git://github.com/xdebug/xdebug.git
cd /usr/src/xdebug
sudo /usr/bin/env phpize
sudo ./configure  --enable-shared --enable-xdebug
sudo make
sudo make install

sudo apt-get autoremove -y

rm /etc/php/*/*/conf.d/20-xdebug.ini

if [ -d /etc/php/5.6/cli/conf.d/ ]; then
    ln -s /vagrant/etc/php/xdebug.ini /etc/php/5.6/cli/conf.d/20-xdebug.ini
fi
if [ -d /etc/php/5.6/fpm/conf.d/ ]; then
    ln -s /vagrant/etc/php/xdebug.ini /etc/php/5.6/fpm/conf.d/20-xdebug.ini
fi
if [ -d /etc/php/7.0/cli/conf.d/ ]; then
    ln -s /vagrant/etc/php/xdebug.ini /etc/php/7.0/cli/conf.d/20-xdebug.ini
fi
if [ -d /etc/php/7.0/fpm/conf.d/ ]; then
ln -s /vagrant/etc/php/xdebug.ini /etc/php/7.0/fpm/conf.d/20-xdebug.ini
fi
if [ -d /etc/php/7.1/cli/conf.d/ ]; then
ln -s /vagrant/etc/php/xdebug.ini /etc/php/7.1/cli/conf.d/20-xdebug.ini
fi
if [ -d /etc/php/7.1/fpm/conf.d/ ]; then
ln -s /vagrant/etc/php/xdebug.ini /etc/php/7.1/fpm/conf.d/20-xdebug.ini
fi
if [ -d /etc/php/7.2/cli/conf.d/ ]; then
ln -s /vagrant/etc/php/xdebug.ini /etc/php/7.2/cli/conf.d/20-xdebug.ini
fi
if [ -d /etc/php/7.2/fpm/conf.d/ ]; then
ln -s /vagrant/etc/php/xdebug.ini /etc/php/7.2/fpm/conf.d/20-xdebug.ini
fi

sudo update-alternatives --set php /usr/bin/php7.2