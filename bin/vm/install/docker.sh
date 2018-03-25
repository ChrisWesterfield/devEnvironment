#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.docker ]
then
    echo "Docker already installed."
    exit 0
fi

touch /home/vagrant/.docker
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu zesty stable"

sudo apt-get update
sudo apt-get install docker-ce


sudo curl -L --fail "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo wget https://github.com/bcicen/ctop/releases/download/v0.5/ctop-0.5-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop
sudo wget https://raw.githubusercontent.com/yadutaf/ctop/master/cgroup_top.py -O /usr/local/bin/chtop
sudo chmod +x /usr/local/bin/chtop