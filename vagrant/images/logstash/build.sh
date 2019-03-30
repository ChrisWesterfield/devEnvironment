#!/usr/bin/env bash
/usr/bin/env docker build -t spectware/logstash:latest .
/usr/bin/env docker push spectware/logstash:latest