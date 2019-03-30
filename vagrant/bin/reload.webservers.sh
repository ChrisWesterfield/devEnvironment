#!/usr/bin/env bash
cd /home/vagrant/base
/usr/bin/env docker-compose -f docker-compose.yaml exec auth_nginx nginx -s reload
/usr/bin/env docker-compose -f docker-compose.yaml exec backend_nginx nginx -s reload
/home/vagrant/base/bin/reload.webproxy.sh