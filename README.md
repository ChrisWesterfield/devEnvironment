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

### 4. install managment tools (requires PHP + Composer)

composer install

(Windows Seperate approach required regarding php and composer)

### 5. install root certificate (into Environment)

#### Windows
./bin/addCA.win.bat

#### Linux
./bin/addCA.linux.sh

#### MacOSX
./bin/addCA.mac.sh

### 6. enter vagrant environment

Unixoed/Cygwin Bash

Virtual Box:

$# ./bin/vb.ssh.sh

Parallels:

$# ./bin/pa.ssh.sh

Other Virtualisation Software or Windows

vagrant(.exe) ssh

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
      
## List of Options

### Install Mailhog
mailhog: true
### Install nodejs
nodejs: true
### Install PHP 5.6
php56: true
### Install PHP 7.0
php70: true
### Install PHP 7.1
php71: true
### Install PHP 7.2
php72: true
### Install PHP Tools for Development (should be enabled on last run if futher php tools are required)
php: true
### Install Redis
redis: true
### Install Memcached
memcache: true
### Install Java Open JDK 8 (JRE + JDK)
java: true
### Install Ant
ant: true
### Install supervisorD
supervisor: true
### Install PHP My Admin (enable it)
phpma: true
### Install Profiler (xhprof/tideways profiler)
profiler: true
### Install xhgui for xhprof/tideways Profiler
xhgui: true
### Install MariaDB
mariadb: true
### Install Master/Slave Config
mariadbMultiMaster: true
mariadbMultiMasterCount: 2

this configures 1 Master 2 Slaves
### Install elasticsearch
elasticsearch: true

or

elasticsearch: 5

or

elasticsearch: 6
### Install kibana
kibana: true
### Install logstash
logstash: true
### Install couchdb
couchdb: true
### Install mongodb
mongodb: true
### Install rabbitmq
rabbitmq: true
### Install cockpit
cockpit: true
### Install statsd
statsd: true
### Install PostgreSQL
postgresql:true
### Install Zend Z-Ray Standalone
zray: true
### Install SqLite
sqlite: true
### Install Oh My ZSH
ohmyzsh: true
### Install beanstalkd
beanstalkd: true
### Install ngrok:
ngrok: true
### Install Jenkins
jenkins: true
### Install PHP QA Tools
qatools: true
### Install Blackfire
blackfire: true
### Install nginx
nginx: true
### Install Apache2
apache2: true
### Yarn JS Tools
yarn: true
### DarkStat
darkstat: true

### Serve Pages as http
to allow pages to be sent also by http or not:

either Site configuration:

serverHttp: true

global Configuration

serverHttp: true

**if this option is enabled an entry for http transfer will be added and the http port not ignored in the settings!**

## Known Issues

## Untestet
Apache