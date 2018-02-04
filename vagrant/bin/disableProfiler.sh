#!/usr/bin/env bash
sudo service mongod stop
sudo systemctl disable mongod
/usr/bin/php /vagrant/bin/sub/disableProfiler.php $1 $2 $3 $4
/vagrant/bin/restartWeb.sh