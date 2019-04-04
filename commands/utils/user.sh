#!/usr/bin/env bash

INSTALL_USER=${2}

echo "[1/3] ~> Create '${INSTALL_USER}'"
EXISTS=$(grep -c ^${INSTALL_USER}: /etc/passwd)
if [ "$EXISTS" = '0' ]; then
  useradd -u 1000 ${INSTALL_USER}
  mkdir -p /home/${INSTALL_USER}/.ssh/
  cp ~/.ssh/authorized_keys /home/${INSTALL_USER}/.ssh/
  chmod 755 /home/${INSTALL_USER}/.ssh/authorized_keys
  chown -R ${INSTALL_USER}:${INSTALL_USER} /home/${INSTALL_USER}
  echo "deploy ALL=(ALL) ALL" > /etc/sudoers.d/deploy
fi

SSH=$(grep -c ^AllowUsers.*${INSTALL_USER}: /etc/ssh/sshd_config)
if [ "$EXISTS" = '0' ]; then
  echo "[2/3] ~> Configure ssh"
  printf '\n%s %s\n' 'AllowUsers' ${INSTALL_USER} >> /etc/ssh/sshd_config
else 
  echo "[2/3] ~> Service ssh can not be modified"
fi

echo "[3/3] ~> Add '${INSTALL_USER}' to docker and root groups"
usermod -aG docker ${INSTALL_USER}
usermod -aG root ${INSTALL_USER}
