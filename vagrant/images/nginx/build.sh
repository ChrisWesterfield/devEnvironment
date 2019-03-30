#!/usr/bin/env bash
/usr/bin/env docker build -t spectware/nginxproxy:latest .
/usr/bin/env docker push spectware/nginxproxy:latest