#!/usr/bin/env bash
if [ -f /home/vagrant/.xhgui ]
then
    echo "XHGUI already installed."
    exit 0
fi
touch /home/vagrant/.xhgui
cd /home/vagrant
wget https://github.com/perftools/xhgui/archive/0.8.1.zip
unzip 0.8.1.zip
mv xhgui-0.8.1 xhgui
rm 0.8.1.zip
cd xhgui
chmod -R 0777 cache
mongo < /vagrant/bin/xhgui.js
php install.php