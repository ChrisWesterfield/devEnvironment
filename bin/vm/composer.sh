#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.phpcomposer ]
then
    echo "Composer already installed."
    exit 0
fi
touch /home/vagrant/.phpcomposer

wget https://getcomposer.org/composer.phar
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer