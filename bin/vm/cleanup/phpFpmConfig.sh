#!/usr/bin/env bash

VERSION=$1

if [ "$VERSION" == "5.6" ] || [ "$VERSION" == "7.0" ] || [ "$VERSION" == "7.1" ] || [ "$VERSION" == "7.2" ]
then
    PATH="/etc/$1/fpm/poold./"
    if [ -d "$PATH" ]
    then
        /usr/bin/env find . ! -name 'www.conf' -type f -exec rm -f {} +
    fi
fi