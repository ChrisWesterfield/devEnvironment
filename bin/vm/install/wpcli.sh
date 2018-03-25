#!/usr/bin/env bash
if [ -f /home/vagrant/.wpcli ]
then
    echo "WordPress CLI already installed."
    exit 0
fi

touch /home/vagrant/.wpcli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp