#!/usr/bin/env bash
/usr/bin/env docker build -t spectware/phpcli:latest .
/usr/bin/env docker tag spectware/phpcli:latest spectware/phpcli:7.3
/usr/bin/env docker push spectware/phpcli:latest
/usr/bin/env docker push spectware/phpcli:7.3