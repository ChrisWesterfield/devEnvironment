#!/usr/bin/env bash


if [ -f /home/vagrant/.qatools ]
then
    echo "QA Tools already installed."
    exit 0
fi
touch /home/vagrant/.qatools

echo "Installing phpunit"
wget -O phpunit https://phar.phpunit.de/phpunit-6.phar
mv phpunit /usr/local/bin/phpunit
chmod +x /usr/local/bin/phpunit
ln -s /usr/local/bin/phpunit /usr/local/bin/phpunit.phar


echo "Installing phpLOC"
wget https://phar.phpunit.de/phploc.phar
mv phploc.phar /usr/local/bin/phploc
chmod +x /usr/local/bin/phploc
ln -s /usr/local/bin/phploc /usr/local/bin/phploc.phar


echo "Installing phpMD"
wget -c http://static.phpmd.org/php/latest/phpmd.phar
mv phpmd.phar /usr/local/bin/phpmd
chmod +x /usr/local/bin/phpmd
ln -s /usr/local/bin/phpmd /usr/local/bin/phpmd.phar


echo "Installing PHP Code Sniffer"
wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
mv phpcs.phar /usr/local/bin/phpcs
chmod +x /usr/local/bin/phpcs
ln -s /usr/local/bin/phpcs /usr/local/bin/phpcs.phar

wget https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar
mv phpcbf.phar /usr/local/bin/phpcbf
chmod +x /usr/local/bin/phpcbf
ln -s /usr/local/bin/phpcbf /usr/local/bin/phpcbf.phar


echo "Installing PHP Copy Paste Detector"
wget https://phar.phpunit.de/phpcpd.phar
mv phpcpd.phar /usr/local/bin/phpcpd
chmod +x /usr/local/bin/phpcpd
ln -s /usr/local/bin/phpcpd /usr/local/bin/phpcpd.phar


echo "Installing PHP Dead Code Detector"
wget https://phar.phpunit.de/phpdcd.phar
mv phpdcd.phar /usr/local/bin/phpdcd
chmod +x /usr/local/bin/phpdcd
ln -s /usr/local/bin/phpdcd /usr/local/bin/phpdcd.phar


echo "Installing Code Ception"
wget https://codeception.com/codecept.phar
mv codecept.phar /usr/local/bin/codecept
chmod +x /usr/local/bin/codecept
ln -s /usr/local/bin/codecept /usr/local/bin/codecept.phar


echo "Installing PHP Metrics"
wget -O phpmetrics.phar https://github.com/phpmetrics/PhpMetrics/blob/master/releases/phpmetrics.phar?raw=true
mv phpmetrics.phar /usr/local/bin/phpmetrics
chmod +x /usr/local/bin/phpmetrics
ln -s /usr/local/bin/phpmetrics /usr/local/bin/phpmetrics.phar


echo "Installing PHP DOX"
wget http://phpdox.de/releases/phpdox.phar
mv phpdox.phar /usr/local/bin/phpdox
chmod +x /usr/local/bin/phpdox
ln -s /usr/local/bin/phpdox /usr/local/bin/phpdox.phar