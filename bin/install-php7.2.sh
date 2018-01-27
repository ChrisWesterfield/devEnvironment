#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.php72 ]
then
    echo "PHP 7.2 already installed."
    exit 0
fi
touch /home/vagrant/.php72
sudo apt-get install -y \
        php7.2-common \
        php7.2-bcmath \
        php7.2-cli \
        php7.2-dev \
        php7.2-enchant \
        php7.2-curl \
        php7.2-imap \
        php7.2-gd \
        php7.2-intl \
        php7.2-json \
        php7.2-ldap \
        php7.2-mbstring \
        php7.2-mysql \
        php7.2-opcache \
        php7.2-pgsql \
        php7.2-pspell \
        php7.2-readline \
        php7.2-recode \
        php7.2-soap \
        php7.2-sqlite3 \
        php7.2-tidy \
        php7.2-xml \
        php7.2-xmlrpc \
        php7.2-zip \
        php7.2-xsl \
        php7.2-fpm

sudo echo "include=/vagrant/etc/fpm-pool.d/*.php7.2.conf" >> /etc/php/7.2/fpm/php-fpm.conf
sudo echo "; configuration for php opcache module" > /etc/php/7.2/mods-available/opcache.ini
sudo echo "; priority=10" >> /etc/php/7.2/mods-available/opcache.ini
sudo echo "zend_extension=opcache.so" >> /etc/php/7.2/mods-available/opcache.ini
sudo echo "opcache.memory_consumption = 512" >> /etc/php/7.2/mods-available/opcache.ini
sudo echo "opcache.max_accelerated_files = 30000" >> /etc/php/7.2/mods-available/opcache.ini
sudo echo "opcache.enable_cli = Off" >> /etc/php/7.2/mods-available/opcache.ini
sudo echo "opcache.interned_strings_buffer=16"  >> /etc/php/7.2/mods-available/opcache.ini
sudo echo "opcache.file_cache=/tmp" >>  /etc/php/7.2/mods-available/opcache.ini
sudo echo "opcache.file_cache_consistency_checks=1" >>  /etc/php/7.2/mods-available/opcache.ini
sudo echo "opcache.fast_shutdown=1" >>  /etc/php/7.2/mods-available/opcache.ini
sudo echo "memory_limit = 512M" > /etc/php/7.2/mods-available/mjr.ini
sudo echo "error_reporting = E_ALL" >> /etc/php/7.2/mods-available/mjr.ini
sudo echo "display_startup_errors = On" >> /etc/php/7.2/mods-available/mjr.ini
sudo echo "display_errors = On" >> /etc/php/7.2/mods-available/mjr.ini
sudo echo "realpath_cache_ttl=7200" >> /etc/php/7.2/mods-available/mjr.ini
sudo echo "realpath_cache_size = 4M" >> /etc/php/7.2/mods-available/mjr.ini
sudo ln -s /etc/php/7.2/mods-available/mjr.ini /etc/php/7.2/fpm/conf.d/20-mjr.ini
sudo ln -s /etc/php/7.2/mods-available/mjr.ini /etc/php/7.2/cli/conf.d/20-mjr.ini