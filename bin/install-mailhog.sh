#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.mailhog ]
then
    echo "Mailhog already installed."
    exit 0
fi
touch /home/vagrant/.mailhog
sudo apt-get install daemon fakeroot -y
cd /usr/src
sudo git clone https://github.com/deogracia/MailHog-debian-package
cd MailHog-debian-package
sudo mkdir -p package/usr/sbin
sudo chmod 755 package/usr/sbin
cd package/usr/sbin
sudo wget https://github.com/mailhog/MailHog/releases/download/v0.1.6/MailHog_linux_amd64
sudo mv MailHog_linux_amd64 mailhog
sudo chmod 755 mailhog
cd ../../..
sudo bash restore-permission.bash
sudo dpkg-deb --build package
sudo mv package.deb mailhog-VERSION-amd64.deb
sudo dpkg -i mailhog-VERSION-amd64.deb

sudo sed -i 's/0.0.0.0:8025/127.0.0.1:8025/g' /etc/default/mailhog
sudo sed -i 's/0.0.0.0:1025/127.0.0.1:1025/g' /etc/default/mailhog