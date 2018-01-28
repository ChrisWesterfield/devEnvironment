#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.php56 ]
then
    echo "PHP 5.6 already installed."
    exit 0
fi
touch /home/vagrant/.php56
sudo apt-get install -y \
        php5.6-common \
        php5.6-bcmath \
        php5.6-cli \
        php5.6-dev \
        php5.6-enchant \
        php5.6-curl \
        php5.6-imap \
        php5.6-gd \
        php5.6-intl \
        php5.6-json \
        php5.6-ldap \
        php5.6-mbstring \
        php5.6-mysql \
        php5.6-opcache \
        php5.6-pgsql \
        php5.6-pspell \
        php5.6-readline \
        php5.6-recode \
        php5.6-soap \
        php5.6-sqlite3 \
        php5.6-tidy \
        php5.6-xml \
        php5.6-xmlrpc \
        php5.6-zip \
        php5.6-xsl \
        php5.6-fpm

sudo echo "include=/vagrant/etc/fpm-pool.d/*.php5.6.conf" >> /etc/php/5.6/fpm/php-fpm.conf
sudo echo "; configuration for php opcache module" > /etc/php/5.6/mods-available/opcache.ini
sudo echo "; priority=10" >> /etc/php/5.6/mods-available/opcache.ini
sudo echo "zend_extension=opcache.so" >> /etc/php/5.6/mods-available/opcache.ini
sudo echo "opcache.memory_consumption = 512" >> /etc/php/5.6/mods-available/opcache.ini
sudo echo "opcache.max_accelerated_files = 30000" >> /etc/php/5.6/mods-available/opcache.ini
sudo echo "opcache.enable_cli = Off" >> /etc/php/5.6/mods-available/opcache.ini
sudo echo "opcache.interned_strings_buffer=16"  >> /etc/php/5.6/mods-available/opcache.ini
sudo echo "opcache.file_cache=/tmp" >>  /etc/php/5.6/mods-available/opcache.ini
sudo echo "opcache.file_cache_consistency_checks=1" >>  /etc/php/5.6/mods-available/opcache.ini
sudo echo "opcache.fast_shutdown=1" >>  /etc/php/5.6/mods-available/opcache.ini
sudo echo "memory_limit = 512M" > /etc/php/5.6/mods-available/mjr.ini
sudo echo "error_reporting = E_ALL" >> /etc/php/5.6/mods-available/mjr.ini
sudo echo "display_startup_errors = On" >> /etc/php/5.6/mods-available/mjr.ini
sudo echo "display_errors = On" >> /etc/php/5.6/mods-available/mjr.ini
sudo echo "realpath_cache_ttl=7200" >> /etc/php/5.6/mods-available/mjr.ini
sudo echo "realpath_cache_size = 4M" >> /etc/php/5.6/mods-available/mjr.ini
sudo ln -s /etc/php/5.6/mods-available/mjr.ini /etc/php/5.6/fpm/conf.d/20-mjr.ini
sudo ln -s /etc/php/5.6/mods-available/mjr.ini /etc/php/5.6/cli/conf.d/20-mjr.ini