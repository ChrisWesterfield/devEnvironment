#!/usr/bin/env bash
if [ -f /home/vagrant/.zendZRay ]
then
    echo "Zend Z-Ray already installed."
    exit 0
fi

touch /home/vagrant/.zendZRay
sudo wget http://repos.zend.com/zend-server/early-access/ZRay-Homestead/zray-standalone-php72.tar.gz -O - | sudo tar -xzf - -C /opt
sudo ln -sf /vagrant/etc/php/zray.ini /etc/php/7.2/cli/conf.d/20-zray.ini
sudo ln -sf /vagrant/etc/php/zray.ini /etc/php/7.2/fpm/conf.d/20-zray.ini
sudo ln -sf /opt/zray/lib/zray.so /usr/lib/php/20170718/zray.so
sudo chown -R vagrant:vagrant /opt/zray