#!/usr/bin/env bash
/usr/bin/env docker build -t spectware/phpfpm:latest .
/usr/bin/env docker tag spectware/phpfpm:latest spectware/phpfpm:7.3
/usr/bin/env docker push spectware/phpfpm:latest
/usr/bin/env docker push spectware/phpfpm:7.3