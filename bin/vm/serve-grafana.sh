#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

declare -A params=$5     # Create an associative array
paramsTXT=""
if [ -n "$5" ]; then
    for element in "${!params[@]}"
    do
        paramsTXT="${paramsTXT}
        fastcgi_param ${element} ${params[$element]};"
    done
fi
listenHttp=""
if [ $6 ]
then
    listenHttp="listen ${3:-80};"
fi

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl http2;
    server_name $1;

    index index.html index.htm index.php app_dev.php;

    charset utf-8;

    location /grafana/ {
            alias /opt/grafana/src/;
            index index.html;
    }

    location / {
            add_header Access-Control-Allow-Origin "*";
            proxy_pass http://127.0.0.1:$2;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }

    access_log off;
    error_log  /vagrant/log/$1-ssl-error.log error;

    ssl_certificate     /etc/ssl/site/$1.crt;
    ssl_certificate_key /etc/ssl/site/$1.key;

    location ~* ^/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
           root /vagrant/phpmyadmin;
    }
}
"

echo "$block" > "/etc/nginx/sites-available/$1.vhost"
ln -fs "/etc/nginx/sites-available/$1.vhost" "/etc/nginx/sites-enabled/$1.vhost"
