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

phpV="${4//.}"

if [ $7 ]
then
    listenHttp="listen ${3:-80};"
fi
listenHttp=""

if [ $phpV == "custome" ]
then
    LISTEN=$8
else
    LISTEN="127.0.0.1:90$phpV"
fi

block="
upstream unicorn_server {
 # This is the socket we configured in unicorn.rb
 server unix:/home/vagrant/errbit/run/errbit.socket
 fail_timeout=0;
}

server {
    $listenHttp
    listen ${3:-443} ssl http2;
    server_name $1;

    client_max_body_size 4G;

    root   /home/vagrant/errbit/public;

    index index.php;

    charset utf-8;

    access_log off;
    error_log  /vagrant/log/$1-ssl-error.log error;

    location / {

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;

        if (!-f $request_filename) {
          proxy_pass http://unicorn_server;
          break;
        }
    }

    location ~ /\.ht {
        deny all;
    }

    ssl_certificate     /etc/ssl/site/$1.crt;
    ssl_certificate_key /etc/ssl/site/$1.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$1.vhost"
ln -fs "/etc/nginx/sites-available/$1.vhost" "/etc/nginx/sites-enabled/$1.vhost"
