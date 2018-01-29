#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# Clear The Old Nginx Sites

rm -f /vagrant/etc/nginx/sites-enabled/*
rm -f /vagrant/etc/nginx/sites-available/*
