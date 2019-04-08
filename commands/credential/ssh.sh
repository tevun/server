#!/usr/bin/env bash

TEVUN_USER_INSTALL=${2}

echo "[1/2] ~> Configure '~/.ssh/authorized_keys'"

mkdir -p /home/${TEVUN_USER_INSTALL}/.ssh/
cp ~/.ssh/authorized_keys /home/${TEVUN_USER_INSTALL}/.ssh/
chmod 755 /home/${TEVUN_USER_INSTALL}/.ssh/authorized_keys
chown -R ${TEVUN_USER_INSTALL}:${TEVUN_USER_INSTALL} /home/${TEVUN_USER_INSTALL}
echo "deploy ALL=(ALL) ALL" > /etc/sudoers.d/deploy

echo "[2/2] ~> Configure '/etc/ssh/sshd_config'"
TEVUN_USER_ALLOWED=$(grep -c ^AllowUsers.*${TEVUN_USER_INSTALL}: /etc/ssh/sshd_config)
if [[ "$TEVUN_USER_ALLOWED" = '0' ]]; then
  printf '\n%s %s\n' 'AllowUsers' ${TEVUN_USER_INSTALL} >> /etc/ssh/sshd_config
fi
