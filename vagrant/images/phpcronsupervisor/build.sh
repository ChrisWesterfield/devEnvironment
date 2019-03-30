#!/usr/bin/env bash
/usr/bin/env docker build -t spectware/phpcronsupervisor:latest .
/usr/bin/env docker tag spectware/phpcronsupervisor:latest spectware/phpcronsupervisor:7.3
/usr/bin/env docker push spectware/phpcronsupervisor:latest
/usr/bin/env docker push spectware/phpcronsupervisor:7.3