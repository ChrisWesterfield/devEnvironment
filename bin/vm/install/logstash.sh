#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.logstash ]
then
    echo "Logstash already installed."
    exit 0
fi
sudo /usr/bin/env bash /vagrant/bin/fix.dns.sh
touch /home/vagrant/.logstash
sudo curl https://artifacts.elastic.co/downloads/logstash/logstash-6.1.1.deb > logstash.deb
sudo dpkg -i /home/vagrant/logstash.deb
sudo rm /home/vagrant/logstash.deb
sudo ln -s /vagrant/etc/logstash/pipeline/logstash.conf /etc/logstash/conf.d/logstash.conf
sudo systemctl enable logstash
sudo service logstash restart