#!/usr/bin/env bash

if grep "source /vagrant/.bash_profile" /home/vagrant/.bashrc > /dev/null
then
    echo ignoring bash_profile, entry exists
else
    echo "source /vagrant/.bash_profile" >> /home/vagrant/.bashrc
fi