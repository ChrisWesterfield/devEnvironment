#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

java -jar /vagrant/bin/java/schemaSpy_5.0.0.jar -dp /vagrant/bin/java/mysql-connector-java-5.1.45-bin.jar -t mysql -db application -host 127.0.0.1 -port 3306 -u root -p 123 -o /vagrant/system/schema -ahic -hq