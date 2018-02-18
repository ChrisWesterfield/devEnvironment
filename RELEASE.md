# 4.2
* added beanstalkd Admin Console install script
* bug fix for xhgui installer
* motd screen update
* removed homestead console command as it was of no use for the current project.
* added munin
* moved features to property features in config.yaml
* fixed an bug in enablin and disabling FPM Services
* general cleanup
* added couddb ui page
* added php Mongo DB Admin Installation
* added setting default php version
* several minor bug fixes
* updates on documentation file
* added Installer for HHVM
# 4.1
* removed phpmyadmin from bundle
* removed xhgui from bundle
* added install script for phpmyadmin which takes the master/slave config into consideration
* added install script for xhgui
* removed phpsysinfo from distribution (without replacement!)
* fixed an bug that prevented darkstat from booting
* added errbit installation with nginx configs
* several bug fixes
* added wordpress cli installation option
* added flyway database migration system 
# 4.0
* Migrated Version Scheme (X.X)
* restructured the bin/vm directory
* added php-fpm support for different configs
* added support to nginx config for custom fpm configs
* added process list in start menu
* several bug fixes for start menu and start process
* added cleanup script for fpm directires
* split up the up process into several units from now on (box config, installation, ngrok config, database setup, nginx/cron/php-fpm config/apache2)
* general Cleanup
# 3.5
* removed .idea directory
* support for creating mysql users
* added db import/export to the triggers (up/halt) in Vagrant file
* added mongodb import/export to the triggers (up/halt) in Vagrant File
* removed plugin installation and moved them to 3 different files, depending on your environment
* added fix for master/slave environment, when db servers would want to wake up
* added in vagrant command for restarting db
# 3.4
* several bug fixes
* added DarkStat to installable features
* removed unnecesary files from nginx (also added them to the gitignore files)
* updated nginx config package
# 3.3
* removed the nginx config directory due to issues with linking in non unix environments
* added packed config directory
* several updates regarding new structures
* fix for dns issues
# 3.2
Several Updates
* refined Init Scripts for vagrant up process
* Apache2 sites are now proxied over nginx (untestet)
* added the capability to route http requests automatically over https or not (opt out feature)
* up commands for parallels/virtualbox/vmware (needed for testing case or if the project was not made for your environment) 
* fixes in init file
* added commands to enable or disable profiler, xdebug and zray
* added phpsysinfo
* updated motd
* moved vagrant up process files to subfolder vm in bin directory
# 3.1
* added Support for Apache with destinctive mod php version
* mongodb now also installs if xhgui is requested
* removed unneeded files after.sh/aliases as the are added during setup anyway
* updates on motd screen
# 3.0.2
* Update in the Symfony4 File
# 3.0.1
Bug Release update
* fix in pa/vb Commands
* updated bash_profile
* added gitignore file
* updates in vagrant.rb file
# 3.0.0
Initial Commit Based on the homestat Vagrant Environment with minor changes
* added Installer for cockpit
* added Installer for beanstalkd
* added installer for docker
* added installer for mongodb
* added installer for mariadb
* added installer for master/slave setup
* added installer for kibana
* added installer for logstash
* added installer for rabbitmq
* added installer for statsd
* modified several of the nginx base templates
* added several config values
* added nginx build from source
* added start menu
* added trigger plugin to vagrant file
* added console
* added phpMyAdmin
* added motd start screen
* added config directory to vagrant directory
* added several predefined commands for the user vagrant
* removed the config.json support (only yaml is supported!)
* added Profiler support for xhprof / tideways
* added QA Tools
* added ant
* added Jenkins
* added apache2
* added webdriver
* added parallels and virtual box ssh commands
* added xhgui
* added startmenu
* added CA Commands (to add the CA Certificate to the System Certificate (for Windows, Linux & mac))