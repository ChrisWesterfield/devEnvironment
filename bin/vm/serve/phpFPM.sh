#!/usr/bin/env bash

NAME=$1
VERSION=$2
LISTEN=$3
PM=$4
MINSPARE=$5
MAXSPARE=$6
MAXCHILDREN=$7
STARTPROCESS=$8
XDEBUG=$9
MAXRAM="${10}"
LOG="${11}"
LOGERROR="${12}"
DISPLAYERROR="${13}"

if [ "$PM" == "static" ] || [ "$PM" == "ondemand" ]
then
PMC="pm.max_children=$MAXCHILDREN
"
else
PMC="pm.max_children=$MAXCHILDREN
pm.start_servers=$STARTPROCESS
pm.min_spare_servers=$MINSPARE
pm.max_spare_servers=$MAXSPARE"
fi

if [ "$XDEBUG" == "1" ]
then
    XDV="on"
else
    XDV="off"
fi


if [ "$LOGERROR" == "1" ]
then
    LDV="on"
else
    LDV="off"
fi


if [ "$DISPLAYERROR" == "1" ]
then
    DDV="on"
else
    DDV="off"
fi

fpmConfig="[$NAME]
user=vagrant
group=vagrant
listen=$LISTEN
listen.owner=vagrant
listen.group=vagrant
pm = $PM
$PMC
php_flag[display_errors] = $DDV
php_flag[xdebug.remote_enable] = $XDV
php_admin_value[error_log] = $LOG
slowlog = $LOG
php_admin_flag[log_errors] = $LDV
php_admin_value[memory_limit] = $MAXRAM
catch_workers_output = yes
"
echo "$fpmConfig" > "/etc/php/$VERSION/fpm/pool.d/$NAME.conf"