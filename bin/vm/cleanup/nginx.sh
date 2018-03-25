#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# Clear The Old Nginx Sites

rm -f /etc/nginx/sites-enabled/*
rm -f /etc/nginx/sites-available/*

echo "server {
	listen 80 default_server;
	listen [::]:80 default_server;
	server_name _;
	return 301 https://\$host\$request_uri;
}" > /etc/nginx/sites-available/default.vhost
ln -s /etc/nginx/sites-available/default.vhost /etc/nginx/sites-enabled/default.vhost