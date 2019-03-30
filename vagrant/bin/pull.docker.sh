#!/usr/bin/env bash
sudo sysctl -w vm.max_map_count=262144
echo "starting 🐳 Docker Instances"
cd /home/vagrant/base
/usr/bin/env docker-compose -f docker-compose.yaml up -d