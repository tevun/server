#!/usr/bin/env bash

INSTALL_USER=${1}

echo "[1/4] ~> Create '${INSTALL_USER}'"
EXISTS=$(grep -c ^${INSTALL_USER}: /etc/passwd)
if [ "$EXISTS" = '0' ]; then
  adduser ${INSTALL_USER}
  mkdir -p /home/${INSTALL_USER}/.ssh/
  cp ~/.ssh/authorized_keys /home/${INSTALL_USER}/.ssh/
  chmod 755 /home/${INSTALL_USER}/.ssh/authorized_keys
  chown -R ${INSTALL_USER}:${INSTALL_USER} /home/${INSTALL_USER}
fi

echo "[2/4] ~> Configure ssh"
SSH=$(grep -c ^AllowUsers.*${INSTALL_USER}: /etc/ssh/sshd_config)
if [ "$EXISTS" = '0' ]; then
  printf '\n%s %s\n' 'AllowUsers' ${INSTALL_USER} >> /etc/ssh/sshd_config
  service ssh reload
fi

echo "[3/4] ~> Add '${INSTALL_USER}' to docker group"
usermod -aG docker ${INSTALL_USER}

echo '[4/4] ~> Enable docker on system'
systemctl enable docker