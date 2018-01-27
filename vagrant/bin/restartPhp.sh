#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
sudo /usr/bin/env service php7.2-fpm restart
sudo /usr/bin/env service php7.1-fpm restart
sudo /usr/bin/env service php7.0-fpm restart
sudo /usr/bin/env service php5.6-fpm restart