#!/usr/bin/env bash

/usr/bin/php /vagrant/bin/sub/disableXdebug.php $1 $2 $3 $4
/vagrant/bin/restartWeb.sh