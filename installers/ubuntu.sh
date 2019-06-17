#!/bin/bash

__plot "[1/8] ~> Clear docker"
apt-get remove docker docker-engine docker.io containerd runc

__plot "[2/8] ~> Install dependencies to install docker"
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

__plot "[3/8] ~> Add key of docker repository"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88

__plot "[4/8] ~> Add docker repository to system"
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

__plot "[5/8] ~> Update system repositories sources"
apt-get update

__plot "[6/8] ~> Install docker"
apt-get install -y docker-ce docker-ce-cli containerd.io
apt-get autoremove -y

__plot "[7/8] ~> Install docker-compose"
INSTALL_DOCKER_COMPOSE=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
sh -c "curl -L https://github.com/docker/compose/releases/download/${INSTALL_DOCKER_COMPOSE}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
chmod +x /usr/local/bin/docker-compose
sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${INSTALL_DOCKER_COMPOSE}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

__plot '[8/8] ~> Enable docker on system'
systemctl enable docker

DOCKER_INSTALLED=$(docker -v)
DOCKER_COMPOSE_INSTALLED=$(docker-compose -v)
__plot "[done] ~> docker -v: $DOCKER_INSTALLED ~> docker-compose -v: $DOCKER_COMPOSE_INSTALLED"
