#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
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
    iotop \
    iftop \
    ufw

sudo add-apt-repository ppa:ondrej/php
sudo apt-get update