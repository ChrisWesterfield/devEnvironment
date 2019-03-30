#!/usr/bin/env bash
/usr/bin/env docker volume create portainer_data
/usr/bin/env docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer