#!/usr/bin/env bash
/usr/bin/env docker build -t spectware/mailhog:latest .
/usr/bin/env docker push spectware/mailhog:latest