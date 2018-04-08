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

**Note 2:** On Firefox the Certificate must be installed manually as Firefox has it's own Certificate Registry and does not use the OS builtin routines!!

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

## System Command Extension
This release includes an System Command Environment.
This tool basicly sets the Environment up and installs features.

    $system
    Symfony 4.0.8 (kernel: src, env: dev, debug: true)
    
    Usage:
      command [options] [arguments]
    
    Options:
      -h, --help            Display this help message
      -q, --quiet           Do not output any message
      -V, --version         Display this application version
          --ansi            Force ANSI output
          --no-ansi         Disable ANSI output
      -n, --no-interaction  Do not ask any interactive question
      -e, --env=ENV         The Environment name. [default: "dev"]
          --no-debug        Switches off debug mode.
      -v|vv|vvv, --verbose  Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug
    
    Available commands:
      about                           Displays information about the current project
      help                            Displays help for a command
      list                            Lists commands
     assets
      assets:install                  Installs bundles web assets under a public directory
     cache
      cache:clear                     Clears the cache
      cache:pool:clear                Clears cache pools
      cache:pool:prune                Prunes cache pools
      cache:warmup                    Warms up an empty cache
     config
      config:dump-reference           Dumps the default configuration for an extension
     debug
      debug:autowiring                Lists classes/interfaces you can use for autowiring
      debug:config                    Dumps the current configuration for an extension
      debug:container                 Displays current services for an application
      debug:event-dispatcher          Displays configured listeners for an application
      debug:router                    Displays current routes for an application
      debug:translation               Displays translation messages information
      debug:twig                      Shows a list of twig functions, filters, globals and tests
     lint
      lint:twig                       Lints a template and outputs encountered errors
      lint:xliff                      Lints a XLIFF file and outputs encountered errors
      lint:yaml                       Lints a file and outputs encountered errors
     mjrone
      mjrone:add:phpfpm               add or remove phpFpm Process
      mjrone:add:web                  add or remove Site
      mjrone:configure:masterslave    install or uninstall MasterSlave
      mjrone:database                 manage database
      mjrone:install                  Install Packages according to config.yaml.
      mjrone:ngrok                    Configure Ngrok
      mjrone:package:ant              install or uninstall Ant
      mjrone:package:apache2          install or uninstall Apache2
      mjrone:package:beanstalkd       install or uninstall BeanstalkD
      mjrone:package:beanstalkdAdmin  install or uninstall BeanstalkdAdmin
      mjrone:package:blackfire        install or uninstall Blackfire
      mjrone:package:cockpit          install or uninstall Zray
      mjrone:package:composer         install or uninstall Composer
      mjrone:package:couchdb          install or uninstall CouchDB
      mjrone:package:darkstat         install or uninstall Darkstat
      mjrone:package:docker           install or uninstall Docker
      mjrone:package:elastic          install or uninstall Elastic Search 5 or 6
      mjrone:package:errbit           install or uninstall Errbit
      mjrone:package:flyway           install or uninstall FlyWay
      mjrone:package:hhvm             install or uninstall Hhvm
      mjrone:package:java             install or uninstall Java
      mjrone:package:jenkins          install or uninstall Jenkins
      mjrone:package:kibana           install or uninstall Kibana
      mjrone:package:logstash         install or uninstall Logstash
      mjrone:package:mailhog          install or uninstall MailHog
      mjrone:package:maria            install or uninstall Maria
      mjrone:package:memcached        install or uninstall Memcached
      mjrone:package:mongo            install or uninstall MongoDb
      mjrone:package:mongodbadmin     install or uninstall MongoDbAdmin
      mjrone:package:mongodbphp       install or uninstall MongoDbPhp
      mjrone:package:munin            install or uninstall Munin
      mjrone:package:mysql            install or uninstall MySQL
      mjrone:package:netdata          install or uninstall Netdata
      mjrone:package:nginx            install or uninstall nginx
      mjrone:package:ngrok            install or uninstall Ngrok
      mjrone:package:nodejs           install or uninstall Nodejs
      mjrone:package:ohmyzsh          install or uninstall OhMyZsh
      mjrone:package:pgsql            install or uninstall PostgreSQL
      mjrone:package:php56            install or uninstall PHP Fpm 5.6
      mjrone:package:php70            install or uninstall PHP Fpm 7.0
      mjrone:package:php71            install or uninstall PHP Fpm 7.1
      mjrone:package:php72            install or uninstall PHP Fpm 7.2
      mjrone:package:phppma           install or uninstall PhpMyAdmin
      mjrone:package:python           install or uninstall Python
      mjrone:package:qatools          install or uninstall QaTools
      mjrone:package:rabbitmq         install or uninstall RabbitMq
      mjrone:package:redis            install or uninstall Redis
      mjrone:package:ruby             install or uninstall Ruby
      mjrone:package:sqlite           install or uninstall Sqlite
      mjrone:package:statsd           install or uninstall Statsd
      mjrone:package:supervisor       install or uninstall Supervisor
      mjrone:package:tideways         install or uninstall Tideways
      mjrone:package:webdriver        install or uninstall WebDriver
      mjrone:package:wpcli            install or uninstall WpCli
      mjrone:package:xdebug           install or uninstall Xdebug
      mjrone:package:xhgui            install or uninstall XhGui
      mjrone:package:yarn             install or uninstall Yarn
      mjrone:package:zray             install or uninstall Zray
      mjrone:packages:list            lists installed packages
      mjrone:packages:requirements    lists installed packages
      mjrone:restart                  Restart Services
      mjrone:sites:phpfpm             PhpFpm Config to Sites
      mjrone:sites:web                generate Website Configs for apache and nginx
     router
      router:match                    Helps debug routes by simulating a path info match
     security
      security:encode-password        Encodes a password.
     translation
      translation:update              Updates the translation file
    [vagrant@vagrant: ~]$

 
 mjrone:package installs software packages.
    
the option -r removes the package (if no dependencies exist).


## Adding/Removing Database and Users

    [vagrant@vagrant: ~]$system mjrone:add:database
    Usage:
      mjrone:database [options] [--] <type> [<database>] [<username>]...
    
    Arguments:
      type                       Database type, supported: mysql, pgsql, couchdb, mongodb (name === input)
      database                   Database to be added
      username                   Add User to Database (only for mysql and pgsql schema: "<username>,<password>,<type>" type is only supported by mysql (type === read or write) always include < and > for each of the fields! suround the complete username with ")
    
    Options:
      -o, --operation=OPERATION  Operation to be executed (c=create, d=drop, l=list === default) [default: "l"]
      -h, --help                 Display this help message
      -q, --quiet                Do not output any message
      -V, --version              Display this application version
          --ansi                 Force ANSI output
          --no-ansi              Disable ANSI output
      -n, --no-interaction       Do not ask any interactive question
      -e, --env=ENV              The Environment name. [default: "dev"]
          --no-debug             Switches off debug mode.
      -v|vv|vvv, --verbose       Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug
    
    Help:
      manage database

Example:

    system mjrone:database mysql test "<test><123><read>" "<test2><123><write>" -o c
    
This creates an database  test.

Assigns the user test with password 123 and read only permissions
The User test2 with password 123 and read + write permissions

-o is the option selector

c=create

d=drop

l=list

## Adding php-fpm instance

    [vagrant@vagrant: ~]$system mjrone:add:phpfpm
    Usage:
      mjrone:add:phpfpm [options] [--] <name> <version>
    
    Arguments:
      name                                           name of the instance
      version                                        PhpVersion
    
    Options:
          --maxChildren=MAXCHILDREN                  max Children (default: 16) [default: 16]
          --maxSpare=MAXSPARE                        max Spare Processes (default: 4) [default: 4]
          --minSpare=MINSPARE                        min Spare Processes (default: 2) [default: 2]
          --maxRam=MAXRAM                            Maximum Ram (default: 512M) [default: "512M"]
          --start=START                              Start Process Count [default: 2]
          --pm=PM                                    Process Manager (static, dynamic or ondemmand - default: dynamic) [default: "dynamic"]
          --xdebug                                   enable XDebug
          --port=PORT                                Prot of Process [default: 9000]
          --processIdleTimeout=PROCESSIDLETIMEOUT    Process Idle Timeout [default: "10s"]
          --maxRequests=MAXREQUESTS                  Maximum Ammount of Requests [default: 200]
          --disableDisplayError=DISABLEDISPLAYERROR  disable Display Errors
          --disableLogErrors=DISABLELOGERRORS        Disable Logging of Errors
          --flags=FLAGS                              Php Flags (--flags="ID=VALUE" (multiple values allowed)
          --values=VALUES                            PHP Values (--values="id=value" (multiple values allowed)
          --listen=LISTEN                            either 127.0.0.1 or path. Don't use any other IP! [default: "127.0.0.1"]
      -r, --remove                                   remove package completley
      -h, --help                                     Display this help message
      -q, --quiet                                    Do not output any message
      -V, --version                                  Display this application version
          --ansi                                     Force ANSI output
          --no-ansi                                  Disable ANSI output
      -n, --no-interaction                           Do not ask any interactive question
      -e, --env=ENV                                  The Environment name. [default: "dev"]
          --no-debug                                 Switches off debug mode.
      -v|vv|vvv, --verbose                           Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug
    
    Help:
      add or remove phpFPM Process

adding an fpm for each of the versions (5.6, 7.0, 7.1, 7.2)

-r removes an fpm process

name needs to be unique

Version can be 5.6, 7.0, 7.1, 7.2

Afterwards (each time or once only, depending on your preferences) you need to execute the command

    system mjrone:sites:phpfpm
    
so the pools are created and PHP Process Managers are restarted.

## Adding Web Site

    [vagrant@vagrant: ~]$system mjrone:add:web
    Usage:
      mjrone:add:web [options] [--] <map>
    
    Arguments:
      map                                                Url of the Website
    
    Options:
          --type=TYPE                                    Type of Site (Example: Symfony4) [default: "Symfony4"]
          --description=DESCRIPTION                      Description
          --to=TO                                        To Path (Path for Site (full Path))
          --fpm=FPM                                      existing fpm server (default or name of an fpm worker [default: "default"]
          --https=HTTPS                                  HTTPs Port [default: 443]
          --http=HTTP                                    HTTP Port
          --charSet=CHARSET                              Char Set of Nginx [default: "utf-8"]
          --fcgiParams=FCGIPARAMS                        Fcgi Params (multiple values allowed)
          --zRay                                         Enable ZRay
          --clientMaxBodySize=CLIENTMAXBODYSIZE          Client Max Body Size in Mbyte (M) [default: 16]
          --proxyApp=PROXYAPP                            Port for Proxy App
          --fcgiBufferSize=FCGIBUFFERSIZE                FCGI Buffer Size [default: "16k"]
          --fcgiConnectionTimeOut=FCGICONNECTIONTIMEOUT  Fcgi Connection Timeout [default: 300]
          --fcgiBuffer=FCGIBUFFER                        Fcgi Buffer Size [default: "4 16k"]
          --fcgiSendTimeOut=FCGISENDTIMEOUT              Fcgi Send Timeout [default: 300]
          --fcgiReadTimeOut=FCGIREADTIMEOUT              Fcgi Read Timeout [default: 300]
          --fcgiBusyBufferSize=FCGIBUSYBUFFERSIZE        Fcgi Read Timeout [default: "64k"]
          --category=CATEGORY                            Category for Site [default: "app"]
      -r, --remove                                       Remove Size
      -h, --help                                         Display this help message
      -q, --quiet                                        Do not output any message
      -V, --version                                      Display this application version
          --ansi                                         Force ANSI output
          --no-ansi                                      Disable ANSI output
      -n, --no-interaction                               Do not ask any interactive question
      -e, --env=ENV                                      The Environment name. [default: "dev"]
          --no-debug                                     Switches off debug mode.
      -v|vv|vvv, --verbose                               Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug
    
    Help:
      add or remove Site

Command adds or removes an site from the config file.

the map argument must be unique.

type defines the Type of the used website template. Possible Templates:

* Apache
* Elgg
* Errbit*
* Html
* Laravel
* PhpApp
* PhpMyAdmin*
* PimCore
* Proxy
* SilverStripe
* Statsd
* Symfony2
* Symfony4
* Xhgui*

The Templates with * are used internaly only.

The Option -zRay requires Zray to be installed

Each time (or finally) the Command 

    system mjrone:sites:web
    
needs to be executed to create websites

PimCore + Apache requires an installed apache. The site is available over the url: http://<domain>:81 or via nginx with the created proxy (it will always be created!)


## Generate FPM + Web Server Files
PHP FPM

    system mjrone:sites:phpfpm

Web Server

    [vagrant@vagrant: ~]$system mjrone:sites:web
    Usage:
      mjrone:sites:web [options]
    
    Options:
      -a, --ignoreApache    
      -x, --ignoreNginx     
      -h, --help            Display this help message
      -q, --quiet           Do not output any message
      -V, --version         Display this application version
          --ansi            Force ANSI output
          --no-ansi         Disable ANSI output
      -n, --no-interaction  Do not ask any interactive question
      -e, --env=ENV         The Environment name. [default: "dev"]
          --no-debug        Switches off debug mode.
      -v|vv|vvv, --verbose  Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug
    
    Help:
      generate Website Configs for apache and nginx
      
      
## Known Issues

## Untested Software
currently we have tested nginx with several website configs.

Tests will take some time, so please be patient and report us any found details.
