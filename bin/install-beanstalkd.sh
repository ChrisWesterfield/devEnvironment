#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.beanstalkd ]
then
    echo "BeanStalkD already installed."
    exit 0
fi

touch /home/vagrant/.beanstalkd

apt-get install -y beanstalkd


sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
/etc/init.d/beanstalkd start

