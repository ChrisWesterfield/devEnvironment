# MJR!ONE Development Environment

##License: MIT
Original: Original Dervived from Laravel homestead

##Installation
### 1. initialize project

    $# ./bin/init.sh

or for Windows

    ./bin/init.bat

### 2. Configure config.yaml 

Configure config.yaml according your requirements
Add the IP Address to pa.ssh.sh or vb.ssh.sh,
if you have an unixoed system or accessing the environment with an Cygwin bash

You need to select and PHP and NGINX Server bevor starting vagrant up or systems will fail!

### 3. run vagrant up

    $# vagrant up

or for Windows

    vagrant.exe up

### 4. install root certificate (into Environment)

#### Windows
    ./bin/addCA.win.bat

#### Linux
    ./bin/addCA.linux.sh

#### MacOSX
    ./bin/addCA.mac.sh
    
**Note:** on Windows the adding might not work. In this case you need to install the certificate manually.

**Note 2:** On Firefox for Windows the Certificate must be installed manually!

### 6. enter vagrant environment

Unixoed/Cygwin Bash

Virtual Box:

    $# ./bin/vb.ssh.sh

Parallels:

    $# ./bin/pa.ssh.sh

Other Virtualisation Software or Windows

    vagrant(.exe) ssh

## Setting default PHP Version

On Root Lvl Config:

    defaultPhp: "7.2"

## Database Config

Example config:

    databases:
        - name: application
          type: mysql
          user:
              - name: application
                password: 123
                type: write
              - name: application
                password: 123
                type: read

for each database there are 4 types valid:

    1. mysql
    2. pgsql
    3. couchdb
    4. mongodb

If you choose mysql you can also specify an user for which two different permission sets can be specified

    1. write
    2. read

User Type read has only select Permission on the database (used for master/slave environments)

## PHP-FPM Configuration

This release includes the capability of configuring additional FPM Processes According to Project Requriements


    fpm:
      - name: demo
        version: "7.2"
        listen: 127.0.0.1:9001
        pm: dynamic
        max_spare: 16
        min_spare: 4
        start_process: 4
        max_children: 32
        max_ram: 512M
        xdebug: true
        
Properties:
### name
Required. Should not contain Empty Space or Special Caracters(", ', ...)
### version
String of the PHP Version

Possible Values
    * "7.2"
    * "7.1"
    * "7.0"
    * "5.6"
###listen: 
Listening Port for PHP-FPM

Either use an Path  (/run/php......)

or an IP with Port.
Best Practise is to use the local host IP 127.0.0.1 (recommended!)

pm: Choose one of the PM Models (ondemand, static, dynamic (default))

The Models ondemand and static only are configured over the parameter *max_children*
### max_spare + min_spare
Min and Max Spare Processes
### start_process
Start Number of Processes
### max_children
Maximum Number of Processes
### max_ram
Maximum Ammount of Ram for Process
### xdebug
enable or disable xdebug
 

## List of Integrated Sites (if Option is enabled)

Each Site needs to be added to sites. If not added, but enabled the default value will be choosen:

SITE.YOURDOMAIN

    - map: vm
      type: ignore
      function: startpage
      desc: "Startpage"
    - map: profiler.vm
      type: ignore
      function: profiler
      desc: "Profiler Server"
    - map: pma.vm
      type: ignore
      function: pma
      desc: "PHP MyAdmin Server"
    - map: rabbit.vm
      type: ignore
      function: rabbit
      desc: "Rabbit MQ Server"
    - map: search.vm
      type: ignore
      function: search
      desc: "Elastic Search Server"
    - map: kibana.vm
      type: ignore
      function: kibana
      desc: "Kibana Server"
    - map: mail.vm
      type: ignore
      function: mail
      desc: "Mail Server"
    - map: cockpit.vm
      type: ignore
      function: cockpit
      desc: "Cockpit"
    - map: ui.vm
      type: ignore
      function: ui
      desc: "Docker UI Server"
    - map: build.vm
      type: ignore
      function: build
      desc: "Build Server"
    - map: info72.vm
      type: ignore
      function: phpinfo
      desc: "PHP Info 7.2"
    - map: info71.vm
      type: ignore
      function: phpinfo
      desc: "PHP Info 7.1"
    - map: info70.vm
      type: ignore
      function: phpinfo
      desc: "PHP Info 7.0"
    - map: info56.vm
      type: ignore
      function: phpinfo
      desc: "PHP Info 5.6"
    - map: darkstat.vm
      type: ignore
      function: darkstat
      desc: "DarkStat"
    - map: errbit.vm
      type: ignore
      function: errbit
      desc: "Errbit"
    - map: bda.vm
      type: ignore
      function: beanstalkdAdmin
      desc: "Beanstalkd Admin"
    - map: munin.vm
      type: ignore
      function: munin
      desc: "Munin"
    - map: "couch.vm"
      type: ignore
      function: couchDbUi
      desc: "Couch DB UI"
    - map: "phpmda.vm"
      type: ignore
      function: phpmda
      desc: "PHP MongoDB Admin"
      
### Website Config

Parameters:

### map
URL of the site
### type
Environment for Configuration

    * apache2
    * elgg
    * laravel
    * pimcore
    * proxy
    * silverstripe
    * spa
    * statmic / PHP Pages
    * symfony2
    * symfony4

The Additional ones (xhgui, pma are for internal use only)
### to
Target Directory in Filesystem
### desc
###php **
PHP Version default: 7.2
Description of site within Start Menu (Text)
### function*
Internal handling of Pages
Should be set to app
###zray*
enable or disable ZRAY (zray: true)
###fpm* | **
Custom FPM Server from the FPM list
If no one exist you should define an PHP Value

=>* optional

=>** fpm overwrite php Version Usage. 

## List of Features
You can install any of the following features. They need to reside under the flag features:

    features:
        php72: true
        

### Install Mailhog
Install Mailhog

    mailhog: true
### Install nodejs
Install NodeJS

    nodejs: true
### Install PHP 5.6
Install PHP 5.6

    php56: true
### Install PHP 7.0
Install PHP 7.0

    php70: true
### Install PHP 7.1
Install Php 7.1

    php71: true
### Install PHP 7.2
Install PHP 7.2

    php72: true
### Install PHP Tools for Development (should be enabled on last run if futher php tools are required)
Install PHP Tools

    php: true
### Install Redis
Install Redis and PHP Extension

    redis: true
### Install Memcached
Install Memcache and PHP Extensions

    memcache: true
### Install Java Open JDK 8 (JRE + JDK)
Install Java 8 JDK

    java: true
### Install Ant
Install Ant Build Tools

    ant: true
### Install supervisorD
Install SuperVisorD

    supervisor: true
### Install PHP My Admin (enable it)
Install PHP MyAdmin

    phpma: true
### Install Profiler (xhprof/tideways profiler)
Install Tideways / xhprof Profiler

    profiler: true
### Install xhgui for xhprof/tideways Profiler
Install XHGui Profiler Frontend

    xhgui: true
### Install MariaDB
Istall MariaDB MySQL Server

    mariadb: true
### Install Master/Slave Config
Enables The Master Slave Environment in MariaDB Mysql Server

    mariadbMultiMaster: true
    mariadbMultiMasterCount: 2

**this example configures 1 Master 2 Slaves**
### Install elasticsearch
Install Elastic Search Server

    elasticsearch: true

or

    elasticsearch: 5

or

    elasticsearch: 6
### Install kibana
Install Kibana 

    kibana: true
### Install logstash
Install logstash

    logstash: true
### Install couchdb
Install CouchDB

    couchdb: true

### Enable CoudDB Ui
Enables the builtin CouchDB Admin UI

    couchdbui: true
### Install mongodb
Install MongoDB

_(Is also triggerd if Installing XHGUI or Errbit)_

    mongodb: true
### Install rabbitmq
Install RabbitMQ + RabbitMQ Admin Plugin

    rabbitmq: true
### Install cockpit
Install Cockpit Server Admin

    cockpit: true
### Install statsd
Install Statsd System

    statsd: true
### Install PostgreSQL
Install PostgreSQL Server

    postgresql:true
### Install Zend Z-Ray Standalone
Install Zend ZRay Standalone

    zray: true
### Install SqLite
Install SQLite

    sqlite: true
### Install Oh My ZSH
Install Oh My ZSH Shell Extension

    ohmyzsh: true
### Install beanstalkd
Install Beanstalkd Queue Server

    beanstalkd: true
### Beanstalkd Admin
Install Web Admin Tool for Beanstalkd

    beanstalkdadmin: true
### Install ngrok:
Install Webserver Proxy NGrok

    ngrok: true
### Install Jenkins
Install Jenkins Build Server

    jenkins: true
### Install PHP QA Tools
Install PHP QA Tools

    qatools: true
### Install Blackfire
Install Blackfire 

    blackfire: true
### Install nginx
Install Nginx Web Server

    nginx: true
### Install Apache2
Install Apache2 Web Server

    apache2: true
### Yarn JS Tools
Install Yarn JS

    yarn: true
### DarkStat
Install Dark Stat

    darkstat: true
### Errbit
Install Errbit error Tracker

    errbit: true
### Flyway
Install Flyway Database Migration Tool

    flyway: true
### wpcli
Install Wordpress Cli

    wpcli: true
### munin
Install Munin

    munin: true
### PHP MongoDB Admin
Install PHP Mongo DB Admin

    phpmda: true
### HHVM
HipHop VM installation

    hhvm: true

### Serve Pages as http
to allow pages to be sent also by http or not:

either Site configuration:

serverHttp: true

global Configuration

serverHttp: true

**if this option is enabled an entry for http transfer will be added and the http port not ignored in the settings!**

## Known Issues
### MySQL Master/Slave not starting
This is an known issue and still under investigation.
To fix this execute the following commands:

    stopMySQL.sh
    fixDb.sh
    startMySQL.sh
    
It currently seems that the master/slave configs sometime fail to boot. The three workaround Scripts fix this issue currently temporary by stopping all Master/Slave Servers (if some are still up and running) starts the debian mysql server and stops it. Afterwards with the last script the master/slave servers are started.

## Untestet
Apache Setup