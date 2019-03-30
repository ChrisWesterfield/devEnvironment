#!/usr/bin/env bash
cd /home/vagrant/base
/usr/bin/env docker-compose -f docker-compose.yaml exec cli_php bash
