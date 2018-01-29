#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl;
    server_name $1;

    location / {
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_http_version 1.1;
        proxy_pass http://127.0.0.1:${2};
    }

    access_log off;
    error_log  /vagrant/log/$1-error.log error;

    ssl_certificate     /vagrant/etc/nginx/ssl/site/$1.crt;
    ssl_certificate_key /vagrant/etc/nginx/ssl/site/$1.key;
}
"

echo "$block" > "/vagrant/etc/nginx/sites-available/$1.vhost"
ln -fs "/vagrant/etc/nginx/sites-available/$1.vhost" "/vagrant/etc/nginx/sites-enabled/$1.vhost"
