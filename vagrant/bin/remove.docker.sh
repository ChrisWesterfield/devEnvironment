#!/bin/bash
# Delete all containers
docker rm $(docker ps -a -q)
# Delete all images
docker rmi $(docker images -q)

docker system prune
docker rm -vf $(docker ps -aq)
docker rmi -f $(docker images -aq)
docker volume prune -f
