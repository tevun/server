#!/bin/bash

cd ${TEVUN_DIR}

if [[ "${2}" ]]; then
  TEVUN_USER_ID=${2}
fi

__plot "[1/6] Configure git"
git config --global user.email ${TEVUN_USER_EMAIL} >> /dev/null
git config --global user.name ${TEVUN_USER_NAME} >> /dev/null

__plot "[2/6] Create projects dir in '${TEVUN_DIR}/projects'"
if [[ ! -d "${TEVUN_DIR}/projects" ]];then
  mkdir -p ${TEVUN_DIR}/projects
fi

__plot "[3/6] Configure permissions of projects dir to user: '${TEVUN_USER_ID}'"
chmod 755 ${TEVUN_DIR}/projects
chown ${TEVUN_USER_ID}:${TEVUN_USER_ID} ${TEVUN_DIR}/projects

__plot "[4/6] Create the symlink in '/projects' and new '.users' file"
if [[ ! -f "${TEVUN_DIR}/.users" ]];then
  cp ${TEVUN_DIR}/.docker/tevun/etc/nginx/.users ${TEVUN_DIR}/.users
fi
if [[ ! -h "/projects" ]];then
  ln -s ${TEVUN_DIR}/projects /projects
fi

__plot "[5/6] Create global docker network"
NETWORK_EXISTS=$(docker network ls -q -f name=reverse-proxy)
if [[ ! "${NETWORK_EXISTS}" ]];then
  docker network create --driver bridge reverse-proxy
fi

__plot "[6/6] Start docker containers"
docker-compose down && docker-compose rm -f && docker-compose up -d

__plot "[FINISH] ~> Tevun is ready with"
__plot " Your server key is: '${TEVUN_UUID}'"
__plot " Use 'tevun help'"
