#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.mongo ]
then
    echo "MongoDB already installed."
    exit 0
fi

touch /home/vagrant/.mongo

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5 2>&1

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list

sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get -yq -o Dpkg::Options::="--force-confnew" install mongodb-org autoconf g++ make openssl libssl-dev libcurl4-openssl-dev pkg-config libsasl2-dev php-dev

sudo ufw allow 27017
sudo sed -i "s/bindIp: .*/bindIp: 0.0.0.0/" /etc/mongod.conf

sudo systemctl enable mongod
sudo systemctl start mongod

sudo rm -rf /tmp/mongo-php-driver /usr/src/mongo-php-driver
git clone -c advice.detachedHead=false -q -b '1.3.3' --single-branch https://github.com/mongodb/mongo-php-driver.git /tmp/mongo-php-driver
sudo mv /tmp/mongo-php-driver /usr/src/mongo-php-driver
cd /usr/src/mongo-php-driver
git submodule -q update --init

if [ -f /home/vagrant/.php56 ]
then
    phpize5.6
    ./configure --with-php-config=/usr/bin/php-config5.6 > /dev/null
    make clean > /dev/null
    make >/dev/null 2>&1
    sudo make install
    sudo chmod 644 /usr/lib/php/20131226/mongodb.so
    sudo bash -c "echo 'extension=mongodb.so' > /etc/php/5.6/mods-available/mongo.ini"
    sudo ln -s /etc/php/5.6/mods-available/mongo.ini /etc/php/5.6/cli/conf.d/20-mongo.ini
    sudo ln -s /etc/php/5.6/mods-available/mongo.ini /etc/php/5.6/fpm/conf.d/20-mongo.ini
    sudo service php5.6-fpm restart
fi

if [ -f /home/vagrant/.php70 ]
then
    phpize7.0
    ./configure --with-php-config=/usr/bin/php-config7.0 > /dev/null
    make clean > /dev/null
    make >/dev/null 2>&1
    sudo make install
    sudo chmod 644 /usr/lib/php/20151012/mongodb.so
    sudo bash -c "echo 'extension=mongodb.so' > /etc/php/7.0/mods-available/mongo.ini"
    sudo ln -s /etc/php/7.0/mods-available/mongo.ini /etc/php/7.0/cli/conf.d/20-mongo.ini
    sudo ln -s /etc/php/7.0/mods-available/mongo.ini /etc/php/7.0/fpm/conf.d/20-mongo.ini
    sudo service php7.0-fpm restart
fi

if [ -f /home/vagrant/.php71 ]
then
    phpize7.1
    ./configure --with-php-config=/usr/bin/php-config7.1 > /dev/null
    make clean > /dev/null
    make >/dev/null 2>&1
    sudo make install
    sudo chmod 644 /usr/lib/php/20160303/mongodb.so
    sudo bash -c "echo 'extension=mongodb.so' > /etc/php/7.1/mods-available/mongo.ini"
    sudo ln -s /etc/php/7.1/mods-available/mongo.ini /etc/php/7.1/cli/conf.d/20-mongo.ini
    sudo ln -s /etc/php/7.1/mods-available/mongo.ini /etc/php/7.1/fpm/conf.d/20-mongo.ini
    sudo service php7.1-fpm restart
fi


if [ -f /home/vagrant/.php72 ]
then
    phpize7.2
    ./configure --with-php-config=/usr/bin/php-config7.2 > /dev/null
    make clean > /dev/null
    make >/dev/null 2>&1
    sudo make install
    sudo chmod 644 /usr/lib/php/20170718/mongodb.so
    sudo bash -c "echo 'extension=mongodb.so' > /etc/php/7.2/mods-available/mongo.ini"
    sudo ln -s /etc/php/7.2/mods-available/mongo.ini /etc/php/7.2/cli/conf.d/20-mongo.ini
    sudo ln -s /etc/php/7.2/mods-available/mongo.ini /etc/php/7.2/fpm/conf.d/20-mongo.ini
    sudo service php7.2-fpm restart
fi

mongo admin --eval "db.createUser({user:'vagrant',pwd:'123',roles:['root']})"


if [ -f /home/vagrant/.php56 ]
then
    cd /usr/src
    sudo git clone https://github.com/mongodb/mongo-php-driver-legacy.git mongodb-legacy
    cd mongodb-legacy
    sudo phpize5.6
    sudo ./configure --with-php-config=/usr/bin/php-config5.6
    sudo make
    sudo make install
    sudo bash -c "echo 'extension=mongo.so' > /etc/php/5.6/mods-available/mongo-legacy.ini"
    sudo ln -s /etc/php/5.6/mods-available/mongo-legacy.ini /etc/php/5.6/cli/conf.d/20-mongo-legacy.ini
    sudo ln -s /etc/php/5.6/mods-available/mongo-legacy.ini /etc/php/5.6/fpm/conf.d/20-mongo-legacy.ini
    sudo service php5.6-fpm restart
fi
