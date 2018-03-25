#!/usr/bin/env bash

if [ -f /home/vagrant/.beanstalk_console ]
then
    echo "Beanstalkd Console already installed."
    exit 0
fi
touch /home/vagrant/.beanstalk_console
cd /home/vagrant
composer create-project ptrofimov/beanstalk_console ./beanstalkd

echo "<?php
\$GLOBALS['config'] = array(
    /**
     * List of servers available for all users
     */
    'servers' => array('Local Beanstalkd' => 'beanstalk://localhost:11300',),
    /**
     * Saved samples jobs are kept in this file, must be writable
     */
    'storage' => dirname(__FILE__) . DIRECTORY_SEPARATOR . 'storage.json',
    /**
     * Optional Basic Authentication
     */
    'auth' => array(
        'enabled' => false,
        'username' => 'admin',
        'password' => 'password',
    ),
    /**
     * Version number
     */
    'version' => '1.7.9',
);" > /home/vagrant/beanstalkd/config.php