#!/usr/bin/env bash
cd /home/vagrant/base
echo "stoping 🐳 Docker Instances"
/usr/bin/env docker-compose -f docker-compose.yaml stop