#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# Clear The Old Nginx Sites

rm -f /vagrant/etc/nginx/sites-enabled/*
rm -f /vagrant/etc/nginx/sites-available/*

echo "server {
	listen 80 default_server;
	listen [::]:80 default_server;
	server_name _;
	return 301 https://\$host\$request_uri;
}" > /vagrant/etc/nginx/sites-available/default.vhost
ln -s /vagrant/etc/nginx/sites-available/default.vhost /vagrant/etc/nginx/sites-enabled/default.vhost