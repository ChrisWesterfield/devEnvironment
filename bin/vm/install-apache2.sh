#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

phpVersion=$1
if phpVersion != "5.6" && phpVersion != "7.0" && phpVersion != "7.1" && phpVersion != "7.2"
then
    phpVersion="7.2"
fi

if [ -f /home/vagrant/.apache2 ]
then
    echo "Apache already installed."
    exit 0
fi
touch /home/vagrant/.apache2

sudo apt-get install apache2 apache2-bin libapache2-mod-wsgi libapache2-mod-python libapache2-mod-fcgid libapache2-mod-geoip libapache2-mod-gnutls libapache2-mpm-prefork -y

sudo apt-get install "libapache2-mod-php$phpVersion" -y

echo "# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 81

#<IfModule ssl_module>
#	Listen 443
#</IfModule>

#<IfModule mod_gnutls.c>
#	Listen 443
#</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet" > /etc/apache2/ports.conf