#!/usr/bin/env bash

if [ -f /home/vagrant/.darkstat ]
then
    echo "Darkstat already installed."
    exit 0
fi

touch /home/vagrant/.darkstat
apt-get install darkstat -y
echo "# Turn this to yes when you have configured the options below.
START_DARKSTAT=yes

# Don't forget to read the man page.

# You must set this option, else darkstat may not listen to
# the interface you want
INTERFACE=\"-i eth0 -i eth1\"

#DIR=\"/var/lib/darkstat\"
#PORT=\"-p 666\"
BINDIP=\"-b 127.0.0.1\"
#LOCAL=\"-l 192.168.0.0/255.255.255.0\"

# File will be relative to \$DIR:
DAYLOG=\"--daylog darkstat.log\"

# Don't reverse resolve IPs to host names
#DNS=\"--no-dns\"

#FILTER=\"not (src net 192.168.0 and dst net 192.168.0)\"

# Additional command line Arguments:
# OPTIONS=\"--syslog --no-macs\"" > /etc/darkstat/init.cfg

systemctl start darkstat
/lib/systemd/systemd-sysv-install enable darkstat
systemctl enable darkstat
service darkstat restart