#!/usr/bin/env bash

/usr/bin/php /vagrant/bin/sub/enableXdebug.php $1 $2 $3 $4
/vagrant/bin/restartWeb.sh