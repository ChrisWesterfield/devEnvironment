#!/usr/bin/env bash
sudo systemctl enable mongod
sudo service mongod start
/usr/bin/php /vagrant/bin/sub/disableProfiler.php $1 $2 $3 $4
/vagrant/bin/restartWeb.sh