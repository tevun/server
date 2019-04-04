#!/usr/bin/env bash

INSTALL_USER=${2}

echo "[1/2] ~> Create '${INSTALL_USER}'"
EXISTS=$(grep -c ^${INSTALL_USER}: /etc/passwd)
if [ "$EXISTS" = '0' ]; then
  useradd -u 1000 ${INSTALL_USER}
fi

echo "[2/2] ~> Add '${INSTALL_USER}' to docker and root groups"
usermod -aG docker ${INSTALL_USER}
usermod -aG root ${INSTALL_USER}
