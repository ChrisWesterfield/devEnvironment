#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# Clear The Old Environment Variables

sed -i '/# Set Vagrant Environment Variable/,+1d' /home/vagrant/.profile
sed -i '/env\[.*/,+1d' /etc/php/5.6/fpm/pool.d/www.conf
sed -i '/env\[.*/,+1d' /etc/php/7.0/fpm/pool.d/www.conf
sed -i '/env\[.*/,+1d' /etc/php/7.1/fpm/pool.d/www.conf
sed -i '/env\[.*/,+1d' /etc/php/7.2/fpm/pool.d/www.conf
