#!/usr/bin/env bash
echo "Starting MySQL"s
sudo service mysqld@1 start
sudo service mysqld@2 start
sudo service mysqld@3 start
sudo service mysqld@4 start
echo "done"