#!/usr/bin/env bash
if [ -f /home/vagrant/.munin ]
then
    echo "munin already installed."
    exit 0
fi

touch /home/vagrant/.munin
apt-get install -y munin munin-plugins-extra
mv /etc/munin/munin.conf /etc/munin/munin.org.conf
echo "
dbdir  /var/lib/munin
htmldir /home/vagrant/munin
logdir /var/log/munin
includedir /etc/munin/munin-conf.d
graph_strategy cron
[dev.test]
    address 127.0.0.1
    use_node_name yes
" > /etc/munin/munin.conf
mkdir /home/vagrant/munin
chown munin:munin /home/vagrant/munin

