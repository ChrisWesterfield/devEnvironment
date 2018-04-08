#!/usr/bin/env bash
if [ -f /home/vagrant/.base ]
then
    echo "base already installed."
    exit 0
fi

touch /home/vagrant/.base

sudo apt-get update
sudo apt-get install -y  \
    make \
    m4 \
    automake \
    bison \
    swapspace \
    zip \
    unzip \
    graphviz \
    language-pack-en-base \
    tmux \
    mysql-client \
    multitail \
    bash-completion \
    graphviz \
    git \
    apt-transport-https \
    haveged \
    htop \
    nmap \
    htop \
    iotop \
    iftop \
    ufw \
    pv \
    bc \
    software-properties-common \
    ssl-cert \
    build-essential \
    curl \
    pv \
    unzip \
    bash-completion

sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install  -y \
        php7.2-common \
        php7.2-bcmath \
        php7.2-cli \
        php7.2-dev \
        php7.2-enchant \
        php7.2-curl \
        php7.2-imap \
        php7.2-gd \
        php7.2-intl \
        php7.2-json \
        php7.2-mbstring

[[ -d dir ]] || git clone https://github.com/ChrisWesterfield/mjrOneSystem /home/vagrant/base/system

sudo ln -sf /home/vagrant/base/system/bin/console /home/vagrant/base/system/bin/system
sudo ln -sf /home/vagrant/base/etc/crontab /etc/cron.d/userVagrant
sudo service apparmor stop
sudo systemctl disable apparmor


sudo apt-get install -y  \
    make \
    m4 \
    automake \
    bison \
    swapspace \
    zip \
    unzip \
    graphviz \
    language-pack-en-base \
    tmux \
    mysql-client \
    multitail \
    bash-completion \
    graphviz \
    git \
    apt-transport-https \
    haveged \
    htop \
    nmap \
    htop \
    iotop \
    iftop \
    ufw \
    pv \
    bc \
    software-properties-common \
    ssl-cert \
    build-essential \
    curl \
    pv \
    unzip \
    bash-completion