#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.php70 ]
then
    echo "PHP 7.0 already installed."
    exit 0
fi
touch /home/vagrant/.php70
sudo apt-get install -y \
        php7.0-common \
        php7.0-bcmath \
        php7.0-cli \
        php7.0-dev \
        php7.0-enchant \
        php7.0-curl \
        php7.0-imap \
        php7.0-gd \
        php7.0-intl \
        php7.0-json \
        php7.0-ldap \
        php7.0-mbstring \
        php7.0-mysql \
        php7.0-opcache \
        php7.0-pgsql \
        php7.0-pspell \
        php7.0-readline \
        php7.0-recode \
        php7.0-soap \
        php7.0-sqlite3 \
        php7.0-tidy \
        php7.0-xml \
        php7.0-xmlrpc \
        php7.0-zip \
        php7.0-xsl \
        php7.0-fpm


sudo echo "include=/vagrant/etc/fpm-pool.d/*.php7.0.conf" >> /etc/php/7.0/fpm/php-fpm.conf
sudo echo "; configuration for php opcache module" > /etc/php/7.0/mods-available/opcache.ini
sudo echo "; priority=10" >> /etc/php/7.0/mods-available/opcache.ini
sudo echo "zend_extension=opcache.so" >> /etc/php/7.0/mods-available/opcache.ini
sudo echo "opcache.memory_consumption = 512" >> /etc/php/7.0/mods-available/opcache.ini
sudo echo "opcache.max_accelerated_files = 30000" >> /etc/php/7.0/mods-available/opcache.ini
sudo echo "opcache.enable_cli = Off" >> /etc/php/7.0/mods-available/opcache.ini
sudo echo "opcache.interned_strings_buffer=16"  >> /etc/php/7.0/mods-available/opcache.ini
sudo echo "opcache.file_cache=/tmp" >>  /etc/php/7.0/mods-available/opcache.ini
sudo echo "opcache.file_cache_consistency_checks=1" >>  /etc/php/7.0/mods-available/opcache.ini
sudo echo "opcache.fast_shutdown=1" >>  /etc/php/7.0/mods-available/opcache.ini
sudo echo "memory_limit = 512M" > /etc/php/7.0/mods-available/mjr.ini
sudo echo "error_reporting = E_ALL" >> /etc/php/7.0/mods-available/mjr.ini
sudo echo "display_startup_errors = On" >> /etc/php/7.0/mods-available/mjr.ini
sudo echo "display_errors = On" >> /etc/php/7.0/mods-available/mjr.ini
sudo echo "realpath_cache_ttl=7200" >> /etc/php/7.0/mods-available/mjr.ini
sudo echo "realpath_cache_size = 4M" >> /etc/php/7.0/mods-available/mjr.ini
sudo ln -s /etc/php/7.0/mods-available/mjr.ini /etc/php/7.0/fpm/conf.d/20-mjr.ini
sudo ln -s /etc/php/7.0/mods-available/mjr.ini /etc/php/7.0/cli/conf.d/20-mjr.ini