#!/usr/bin/env bash
/usr/bin/env docker build -t spectware/rabbitmq:latest .
/usr/bin/env docker push spectware/rabbitmq:latest