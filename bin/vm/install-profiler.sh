#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.profiler ]
then
    echo "Profiler already installed."
    exit 0
fi
touch /home/vagrant/.profiler

sudo apt-get install php5.6-xhprof


sudo apt-get install libcurl4-openssl-dev libpcre3-dev -y
cd /usr/src
sudo git clone https://github.com/tideways/php-profiler-extension.git
cd php-profiler-extension


sudo make clean
sudo phpize7.2
sudo ./configure
sudo make
sudo make install
sudo ln -s /vagrant/etc/profiler.7.0.ini /etc/php/7.2/fpm/conf.d/20-profiler.ini
sudo ln -s /vagrant/etc/profiler.7.0.ini /etc/php/7.2/cli/conf.d/20-profiler.ini

sudo make clean
sudo phpize7.1
sudo ./configure
sudo make
sudo make install
sudo ln -s /vagrant/etc/profiler.7.1.ini /etc/php/7.1/fpm/conf.d/20-profiler.ini
sudo ln -s /vagrant/etc/profiler.7.1.ini /etc/php/7.1/cli/conf.d/20-profiler.ini

sudo make clean
sudo phpize7.0
sudo ./configure
sudo make
sudo make install
sudo ln -s /vagrant/etc/profiler.7.2.ini /etc/php/7.0/fpm/conf.d/20-profiler.ini
sudo ln -s /vagrant/etc/profiler.7.2.ini /etc/php/7.0/cli/conf.d/20-profiler.ini


