#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.supervisor ]
then
    echo "SuperVisord already installed."
    exit 0
fi

touch /home/vagrant/.supervisor

sudo apt-get install supervisor -y

sudo echo "; supervisor config file
[unix_http_server]
file=/var/run/supervisor.sock   ; (the path to the socket file)
chmod=0700                       ; sockef file mode (default 0700)
[supervisord]
logfile=/var/log/supervisor/supervisord.log
pidfile=/var/run/supervisord.pid
childlogdir=/var/log/supervisor
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
[supervisorctl]
serverurl=unix:///var/run/supervisor.sock
[include]
files = /vagrant/etc/supervisor/*.conf" > /etc/supervisor/supervisord.conf

sudo service supervisor restart