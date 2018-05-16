#!/bin/bash

BASE=$(dirname $(dirname $(readlink -f ${0})))
source ${BASE}/commands/colors

INSTALL_USER="$1"
INSTALL_DOCKER="$2"
INSTALL_DOCKER_COMPOSE="$3"
INSTALL_REBOOT="$4"
INSTALL_LOCALE="$5"

if [ "$INSTALL_USER" = '' ]; then
  INSTALL_USER='heimdall'
fi
if [ "$INSTALL_DOCKER" = '' ]; then
  INSTALL_DOCKER='edge'
fi
if [ "$INSTALL_DOCKER_COMPOSE" = '' ]; then
  INSTALL_DOCKER_COMPOSE='edge'
fi
if [ "$INSTALL_REBOOT" = '' ]; then
  INSTALL_REBOOT='yes'
fi
if [ "$INSTALL_LOCALE" = '' ]; then
  INSTALL_LOCALE='yes'
fi

if [ "${INSTALL_LOCALE}" = 'yes' ]; then
  yellow "[locale] ~> Fix server locale"
  apt-get install -y language-pack-pt
  locale-gen --purge en_US en_US.UTF-8 pt_BR.UTF-8
  dpkg-reconfigure locales
  # echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale
fi

yellow "[1/8] ~> Install dependencies to install docker"
apt-get install -y apt-transport-https ca-certificates curl software-properties-common php-cli

yellow "[2/8] ~> Add key of docker repository"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

yellow "[3/8] ~> Add docker repository to system"
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu artful stable"

yellow "[4/8] ~> Update system repositories sources"
apt-get update

yellow "[5/8] ~> Install docker version ${INSTALL_DOCKER}"
if [ "$INSTALL_DOCKER" = 'edge' ]; then
  apt-get install -y docker-ce
else
  apt-get install -y docker-ce=${INSTALL_DOCKER}
fi
apt-get autoremove -y

if [ ${INSTALL_DOCKER_COMPOSE} = 'edge' ]; then
  INSTALL_DOCKER_COMPOSE=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
fi
sh -c "curl -L https://github.com/docker/compose/releases/download/${INSTALL_DOCKER_COMPOSE}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
chmod +x /usr/local/bin/docker-compose
sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${INSTALL_DOCKER_COMPOSE}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

yellow "[6/8] ~> Add user '${INSTALL_USER}' to system"
EXISTS=$(grep -c ^${INSTALL_USER}: /etc/passwd)
if [ "$EXISTS" = '0' ]; then
  adduser ${INSTALL_USER}
  mkdir -p /home/${INSTALL_USER}/.ssh/
  cp ~/.ssh/authorized_keys /home/${INSTALL_USER}/.ssh/
  # cp ${DIR}/._bash /home/${INSTALL_USER}/._bash
  # printf '\n%s\n' 'source ._bash' >> /home/${INSTALL_USER}/.bashrc
  # mv ${DIR} /home/${INSTALL_USER}/sm
  chmod 755 /home/${INSTALL_USER}/.ssh/authorized_keys
  chown -R ${INSTALL_USER}:${INSTALL_USER} /home/${INSTALL_USER}
fi
SSH=$(grep -c ^AllowUsers.*${INSTALL_USER}: /etc/ssh/sshd_config)
if [ "$EXISTS" = '0' ]; then
  printf '\n%s %s\n' 'AllowUsers' ${INSTALL_USER} >> /etc/ssh/sshd_config
  service ssh reload
fi

yellow "[7/8] ~> Add '${INSTALL_USER}' to docker group"
usermod -aG docker ${INSTALL_USER}

yellow '[8/8] ~> Enable docker on system'
systemctl enable docker

DOCKER_INSTALLED=$(docker -v)
DOCKER_COMPOSE_INSTALLED=$(docker-compose -v)
blue "[done] ~> docker -v: $DOCKER_INSTALLED | docker-compose -v: $DOCKER_COMPOSE_INSTALLED"
blue '[reboot] ~> Reboot your system!!'
if [ "${INSTALL_REBOOT}" = 'yes' ]; then
  red 'Bye Bye!'
  reboot
fi

