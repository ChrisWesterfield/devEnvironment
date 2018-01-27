#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.rabbitmq ]
then
    echo "RabbitMQ already installed."
    exit 0
fi

touch /home/vagrant/.rabbitmq
sudo apt-get update
sudo echo "# /etc/apt/preferences.d/erlang" > /etc/apt/preferences.d/erlang
sudo echo "Package: erlang*" >> /etc/apt/preferences.d/erlang
sudo echo "Pin: version 1:19.3-1" >> /etc/apt/preferences.d/erlang
sudo echo "Pin-Priority: 1000" >> /etc/apt/preferences.d/erlang
sudo echo "Package: esl-erlang" >> /etc/apt/preferences.d/erlang
sudo echo "Pin: version 1:19.3.6" >> /etc/apt/preferences.d/erlang
sudo echo "Pin-Priority: 1000" >> /etc/apt/preferences.d/erlang

sudo apt-get install rabbitmq-server php-amqp erlang-nox  -y
sudo rabbitmq-plugins enable rabbitmq_management