#!/usr/bin/env bash
cd /home/vagrant/base
sudo sysctl -w vm.max_map_count=262144
echo "starting 🐳 Docker Instances"
/usr/bin/env docker-compose -f docker-compose.yaml up -d
echo "starting 🐳 Docker Instances DONE"
