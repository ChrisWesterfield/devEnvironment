#!/usr/bin/env bash


if [ -f /home/vagrant/.qatools ]
then
    echo "QA Tools already installed."
    exit 0
fi
touch /home/vagrant/.qatools
composer global require "phpunit/phpunit=4.1.*"
composer global require behat/behat='~3.0.6'
composer global require 'phploc/phploc=*'
composer global require 'phpmd/phpmd=*'
composer global require 'squizlabs/php_codesniffer=*'
composer global require 'sebastian/phpcpd=*'
composer global require 'sebastian/phpdcd=*'