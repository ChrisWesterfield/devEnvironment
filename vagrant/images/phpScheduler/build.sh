#!/usr/bin/env bash
/usr/bin/env docker build -t spectware/phpscheduled:latest .
/usr/bin/env docker tag spectware/phpscheduled:latest spectware/phpscheduled:7.3
/usr/bin/env docker push spectware/phpscheduled:latest
/usr/bin/env docker push spectware/phpscheduled:7.3