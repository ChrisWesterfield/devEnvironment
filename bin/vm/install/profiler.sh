#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.profiler ]
then
    echo "Profiler already installed."
    exit 0
fi
touch /home/vagrant/.profiler

if [ -f /home/vagrant/.php56 ]
then
sudo apt-get install php5.6-xhprof
fi

if [ -f /home/vagrant/.php72 ] || [ -f /home/vagrant/.php71 ] || [ -f /home/vagrant/.php70 ]
then
    sudo apt-get install libcurl4-openssl-dev libpcre3-dev -y
    cd /usr/src
    sudo git clone https://github.com/tideways/php-profiler-extension.git
    cd php-profiler-extension
fi

if [ -f /home/vagrant/.php72 ]
then
    sudo make clean
    sudo phpize7.2
    sudo ./configure --with-php-config=/usr/bin/php-config7.2
    sudo make
    sudo make install
    sudo ln -s /vagrant/etc/php/profiler.7.2.ini /etc/php/7.2/fpm/conf.d/20-profiler.ini
    sudo ln -s /vagrant/etc/php/profiler.7.2.ini /etc/php/7.2/cli/conf.d/20-profiler.ini
fi

if [ -f /home/vagrant/.php71 ]
then
    sudo make clean
    sudo rm configure.ac -f
    sudo rm configure.in -f
    sudo phpize7.1
    sudo ./configure --with-php-config=/usr/bin/php-config7.1
    sudo make
    sudo make install
    sudo ln -s /vagrant/etc/php/profiler.7.1.ini /etc/php/7.1/fpm/conf.d/20-profiler.ini
    sudo ln -s /vagrant/etc/php/profiler.7.1.ini /etc/php/7.1/cli/conf.d/20-profiler.ini
fi

if [ -f /home/vagrant/.php70 ]
then
    sudo make clean
    sudo rm configure.ac -f
    sudo rm configure.in -f
    sudo phpize7.0
    sudo ./configure --with-php-config=/usr/bin/php-config7.1
    sudo make
    sudo make install
    sudo ln -s /vagrant/etc/php/profiler.7.0.ini /etc/php/7.0/fpm/conf.d/20-profiler.ini
    sudo ln -s /vagrant/etc/php/profiler.7.0.ini /etc/php/7.0/cli/conf.d/20-profiler.ini
fi


