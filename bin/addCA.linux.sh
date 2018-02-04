#!/usr/bin/env bash
sudo cp  ./vagrant/etc/nginx/ssl/ca/vagrant.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates