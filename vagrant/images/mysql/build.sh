#!/usr/bin/env bash
/usr/bin/env docker build -t spectware/mysql:latest .
/usr/bin/env docker tag spectware/mysql:latest spectware/mysql:8.0
/usr/bin/env docker push spectware/mysql:latest
/usr/bin/env docker push spectware/mysql:8.0