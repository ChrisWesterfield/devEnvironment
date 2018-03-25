#!/usr/bin/env bash

if [ -f "/home/vagrant/.errbit" ]
then
    sudo /vagrant/bin/errbit.sh start
fi