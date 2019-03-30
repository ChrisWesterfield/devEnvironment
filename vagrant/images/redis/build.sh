#!/usr/bin/env bash
/usr/bin/env docker build -t spectware/redis:latest .
/usr/bin/env docker push spectware/redis:latest