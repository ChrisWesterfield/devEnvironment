#!/usr/bin/env bash

if [ -f /home/vagrant/.hhvm ]
then
    echo "HHVM already installed."
    exit 0
fi

touch /home/vagrant/.hhvm
apt-get update
apt-get install software-properties-common apt-transport-https
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xB4112585D386EB94
add-apt-repository https://dl.hhvm.com/ubuntu
/vagrant/bin/fix.dns.sh
apt-get update

apt-get install hhvm hhvm-dev -y


echo "; php options

pid = /var/run/hhvm/pid

; hhvm specific

hhvm.server.port = 9900
hhvm.server.type = fastcgi
hhvm.server.default_document = index.php
hhvm.log.use_log_file = true
hhvm.log.file = /vagrant/log/hhvm.error.log
hhvm.repo.central.path = /var/cache/hhvm/hhvm.hhbc
" > /etc/hhvm/server.ini

echo "## This is a configuration file for /etc/init.d/hhvm.
## Overwrite start up configuration of the hhvm service.
##
## This file is sourced by /bin/sh from /etc/init.d/hhvm.

## Configuration file location.
## Default: \"/etc/hhvm/server.ini\"
## Examples:
##   \"/etc/hhvm/conf.d/fastcgi.ini\" Load configuration file from Debian/Ubuntu conf.d style location
#CONFIG_FILE=\"/etc/hhvm/server.ini\"

## User to run the service as.
## Default: \"www-data\"
## Examples:
##   \"hhvm\"   Custom 'hhvm' user
##   \"nobody\" RHEL/CentOS 'www-data' equivalent
RUN_AS_USER=\"vagrant\"
RUN_AS_GROUP=\"vagrant\"

## Add additional arguments to the hhvm service start up that you can't put in CONFIG_FILE for some reason.
## Default: \"\"
## Examples:
##   \"-vLog.Level=Debug\"                Enable debug log level
##   \"-vServer.DefaultDocument=app.php\" Change the default document
#ADDITIONAL_ARGS=\"\"

## PID file location.
## Default: \"/var/run/hhvm/pid\"
#PIDFILE=\"/var/run/hhvm/pid\"" >/etc/default/hhvm