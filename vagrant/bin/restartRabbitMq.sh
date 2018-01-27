#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
echo "Restarting RabbitMQ"
sudo /usr/bin/env service rabbitmq-server restart