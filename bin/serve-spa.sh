#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

declare -A params=$6     # Create an associative array
paramsTXT=""
if [ -n "$6" ]; then
   for element in "${!params[@]}"
   do
      paramsTXT="${paramsTXT}
      fastcgi_param ${element} ${params[$element]};"
   done
fi

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl http2;
    server_name $1;
    root \"$2\";

    index index.html;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /vagrant/log/$1-error.log error;

    sendfile off;

    client_max_body_size 100m;

    location ~ /\.ht {
        deny all;
    }

    $paramsTXT

    ssl_certificate     /vagrant/etc/nginx/ssl/site/$1.crt;
    ssl_certificate_key /vagrant/etc/nginx/ssl/site/$1.key;
}
"

echo "$block" > "/vagrant/etc/nginx/sites-available/$1.vhost"
ln -fs "/vagrant/etc/nginx/sites-available/$1.vhost" "/vagrant/etc/nginx/sites-enabled/$1.vhost"
