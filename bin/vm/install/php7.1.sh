#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.php71 ]
then
    echo "PHP 7.1 already installed."
    exit 0
fi
touch /home/vagrant/.php71
sudo apt-get install -y \
        php7.1-common \
        php7.1-bcmath \
        php7.1-cli \
        php7.1-dev \
        php7.1-enchant \
        php7.1-curl \
        php7.1-imap \
        php7.1-gd \
        php7.1-intl \
        php7.1-json \
        php7.1-ldap \
        php7.1-mbstring \
        php7.1-mysql \
        php7.1-opcache \
        php7.1-pgsql \
        php7.1-pspell \
        php7.1-readline \
        php7.1-recode \
        php7.1-soap \
        php7.1-sqlite3 \
        php7.1-tidy \
        php7.1-xml \
        php7.1-xmlrpc \
        php7.1-zip \
        php7.1-xsl \
        php7.1-fpm

sudo echo "include=/vagrant/etc/fpm-pool.d/*.php7.1.conf" >> /etc/php/7.1/fpm/php-fpm.conf
sudo echo "; configuration for php opcache module" > /etc/php/7.1/mods-available/opcache.ini
sudo echo "; priority=10" >> /etc/php/7.1/mods-available/opcache.ini
sudo echo "zend_extension=opcache.so" >> /etc/php/7.1/mods-available/opcache.ini
sudo echo "opcache.memory_consumption = 512" >> /etc/php/7.1/mods-available/opcache.ini
sudo echo "opcache.max_accelerated_files = 30000" >> /etc/php/7.1/mods-available/opcache.ini
sudo echo "opcache.enable_cli = Off" >> /etc/php/7.1/mods-available/opcache.ini
sudo echo "opcache.interned_strings_buffer=16"  >> /etc/php/7.1/mods-available/opcache.ini
sudo echo "opcache.file_cache=/tmp" >>  /etc/php/7.1/mods-available/opcache.ini
sudo echo "opcache.file_cache_consistency_checks=1" >>  /etc/php/7.1/mods-available/opcache.ini
sudo echo "opcache.fast_shutdown=1" >>  /etc/php/7.1/mods-available/opcache.ini
sudo echo "memory_limit = 512M" > /etc/php/7.1/mods-available/mjr.ini
sudo echo "error_reporting = E_ALL" >> /etc/php/7.1/mods-available/mjr.ini
sudo echo "display_startup_errors = On" >> /etc/php/7.1/mods-available/mjr.ini
sudo echo "display_errors = On" >> /etc/php/7.1/mods-available/mjr.ini
sudo echo "realpath_cache_ttl=7200" >> /etc/php/7.1/mods-available/mjr.ini
sudo echo "realpath_cache_size = 4M" >> /etc/php/7.1/mods-available/mjr.ini
sudo ln -s /etc/php/7.1/mods-available/mjr.ini /etc/php/7.1/fpm/conf.d/20-mjr.ini
sudo ln -s /etc/php/7.1/mods-available/mjr.ini /etc/php/7.1/cli/conf.d/20-mjr.ini