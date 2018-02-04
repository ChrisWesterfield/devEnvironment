#!/usr/bin/env bash

# install apache and bzip PHP extension
export DEBIAN_FRONTEND=noninteractive
sudo service nginx stop
apt-get update
apt-get install -y apache2 libapache2-mod-fastcgi
apt-get install -y php"$5"-bz2

block="<VirtualHost *:$3>
    ServerName $1
    ServerAlias *.$1

    DocumentRoot $2
    <Directory $2>
        AllowOverride All
        Require all granted
    </Directory>

    # Force Apache to pass the Authorization header to PHP:
    # required for "basic_auth" under PHP-FPM and FastCGI
    SetEnvIfNoCase ^Authorization\$ \"(.+)\" HTTP_AUTHORIZATION=\$1

    # Using SetHandler avoids issues with using ProxyPassMatch in combination
    # with mod_rewrite or mod_autoindex
    <FilesMatch \.php$>
        SetHandler \"proxy:unix:/var/run/php/php$5-fpm.sock|fcgi://localhost\"
    </FilesMatch>

    ErrorLog \${APACHE_LOG_DIR}/$1-error.log
    CustomLog \${APACHE_LOG_DIR}/$1-access.log combined
</VirtualHost>
"


echo "$block" > "/etc/apache2/sites-available/$1.conf"

sudo a2dissite 000-default
sudo a2ensite $1

ps auxw | grep apache2 | grep -v grep > /dev/null

sudo a2enmod rewrite proxy proxy_fcgi
service apache2 restart

if [ $? == 0 ]
then
    service apache2 reload
fi
