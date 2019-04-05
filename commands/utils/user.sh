#!/usr/bin/env bash

TEVUN_USER_INSTALL=${2}

echo "[1/2] ~> Create '${TEVUN_USER_INSTALL}'"
EXISTS=$(grep -c ^${TEVUN_USER_INSTALL}: /etc/passwd)
if [ "$EXISTS" = '0' ]; then
  useradd -u 1000 ${TEVUN_USER_INSTALL}
fi

echo "[2/2] ~> Add '${TEVUN_USER_INSTALL}' to docker and root groups"
usermod -aG docker ${TEVUN_USER_INSTALL}
usermod -aG root ${TEVUN_USER_INSTALL}
