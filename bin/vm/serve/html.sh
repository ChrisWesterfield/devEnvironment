#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ $5 ]
then
    listenHttp="listen ${3:-80};"
fi
listenHttp=""


block="server {
    $listenHttp
    listen ${2:-443} ssl http2;
    server_name $1;
	root $4;

    index index.html index.htm index.php app_dev.php;

    charset utf-8;


    location ~ /\.ht {
        deny all;
    }

    ssl_certificate     /etc/ssl/site/$1.crt;
    ssl_certificate_key /etc/ssl/site/$1.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$1.vhost"
ln -fs "/etc/nginx/sites-available/$1.vhost" "/etc/nginx/sites-enabled/$1.vhost"
