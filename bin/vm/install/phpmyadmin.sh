#!/usr/bin/env bash
if [ -f /home/vagrant/.phpmyadmin ]
then
    echo "PHPMyAdmin already installed."
    exit 0
fi

touch /home/vagrant/.phpmyadmin
cd /home/vagrant
wget https://github.com/phpmyadmin/phpmyadmin/archive/RELEASE_4_7_7.zip
unzip RELEASE_4_7_7.zip
mv phpmyadmin-RELEASE_4_7_7 phpmyadmin
cd phpmyadmin
composer install -vvv --profile

cd themes
wget https://files.phpmyadmin.net/themes/fallen/0.5/fallen-0.5.zip
unzip fallen-0.5.zip

rm /home/vagrant/RELEASE_4_7_7.zip -f
rm fallen-0.5.zip -f