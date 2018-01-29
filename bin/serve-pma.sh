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

phpV="${4//.}"

block="server {
    listen ${2:-80};
    listen ${3:-443} ssl http2;
    server_name $1;
	root /vagrant/phpmyadmin;

    index index.html index.htm index.php app_dev.php;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /app_dev.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /vagrant/log/$1-ssl-error.log error;

    sendfile off;

    client_max_body_size 100m;

    location ~ ^/(.+\.php)$ {
        fastcgi_split_path_info ^(.+\.php)(/.*)\$;
        fastcgi_pass 127.0.0.1:90$phpV;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        $paramsTXT

        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
    }

    location ~ /\.ht {
        deny all;
    }

    ssl_certificate     /vagrant/etc/nginx/ssl/site/$1.crt;
    ssl_certificate_key /vagrant/etc/nginx/ssl/site/$1.key;

    location ~* ^/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
           root /vagrant/phpmyadmin;
    }
}
"

echo "$block" > "/vagrant/etc/nginx/sites-available/$1.vhost"
ln -fs "/vagrant/etc/nginx/sites-available/$1.vhost" "/vagrant/etc/nginx/sites-enabled/$1.vhost"
