#!/bin/bash

cd ${TEVUN_DIR}

if [[ "${2}" ]]; then
  TEVUN_USER_ID=${2}
fi

__plot "[1/7] Configure git"
git config --global user.email ${TEVUN_USER_EMAIL} >> /dev/null
git config --global user.name ${TEVUN_USER_NAME} >> /dev/null

__plot "[2/7] Define env properties"
cp .env.sample .env
#TEVUN_HOST={TEVUN_HOST}
#TEVUN_PORT_HTTP={TEVUN_PORT_HTTP}
#TEVUN_PORT_HTTPS={TEVUN_PORT_HTTPS}
#TEVUN_PORT_SSH={TEVUN_PORT_SSH}

#TEVUN_USER_ID={TEVUN_USER_ID}

TEVUN_HOST="localhost"
if [[ "${@}" != *"--quiet"* ]]; then
  echo -n " Host? (IP or FQDN) [localhost]: "
  read TEVUN_HOST
fi
sed -i "s/{TEVUN_HOST}/${TEVUN_HOST}/g" .env

TEVUN_PORT_HTTP="1080"
if [[ "${@}" != *"--quiet"* ]]; then
  echo -n " HTTP port? [1080]: "
  read TEVUN_PORT_HTTP
fi
sed -i "s/{TEVUN_PORT_HTTP}/${TEVUN_PORT_HTTP}/g" .env

TEVUN_PORT_HTTPS="10443"
if [[ "${@}" != *"--quiet"* ]]; then
  echo -n " HTTPS port? [10443]: "
  read TEVUN_PORT_HTTPS
fi
sed -i "s/{TEVUN_PORT_HTTPS}/${TEVUN_PORT_HTTPS}/g" .env

TEVUN_PORT_SSH="1022"
if [[ "${@}" != *"--quiet"* ]]; then
  echo -n " SSH port? [1022]: "
  read TEVUN_PORT_SSH
fi
sed -i "s/{TEVUN_PORT_SSH}/${TEVUN_PORT_SSH}/g" .env

TEVUN_USER_ID="1000"
if [[ "${@}" != *"--quiet"* ]]; then
  echo -n " User ID to be used in project? [1000]: "
  read TEVUN_USER_ID
fi
sed -i "s/{TEVUN_USER_ID}/${TEVUN_USER_ID}/g" .env

chown ${TEVUN_USER_ID}:${TEVUN_USER_ID} ${TEVUN_DIR}/.env

__plot "[3/7] Create projects dir in '${TEVUN_DIR}/projects'"
if [[ ! -d "${TEVUN_DIR}/projects" ]];then
  mkdir -p ${TEVUN_DIR}/projects
fi

__plot "[4/7] Configure permissions of projects dir to user: '${TEVUN_USER_ID}'"
chmod 755 ${TEVUN_DIR}/projects
chown ${TEVUN_USER_ID}:${TEVUN_USER_ID} ${TEVUN_DIR}/projects

__plot "[5/7] Create the symlink in '/projects', new '.users' file and 'docker-compose.yml'"
if [[ ! -h /projects ]];then
  ln -s ${TEVUN_DIR}/projects /projects
fi
if [[ ! -f ${TEVUN_DIR}/.users ]];then
  cp ${TEVUN_DIR}/.users.sample ${TEVUN_DIR}/.users
  chown ${TEVUN_USER_ID}:${TEVUN_USER_ID} ${TEVUN_DIR}/.users
fi
if [[ ! -f ${TEVUN_DIR}/docker-compose.yml ]];then
  cp ${TEVUN_DIR}/docker-compose.yml.sample ${TEVUN_DIR}/docker-compose.yml
  chown ${TEVUN_USER_ID}:${TEVUN_USER_ID} ${TEVUN_DIR}/docker-compose.yml
fi

__plot "[6/7] Create global docker network"
NETWORK_EXISTS=$(docker network ls -q -f name=reverse-proxy)
if [[ ! "${NETWORK_EXISTS}" ]];then
  docker network create --driver bridge reverse-proxy
fi

__plot "[7/7] Start docker containers"
docker-compose down && docker-compose rm -f && docker-compose up -d

__plot "[FINISH] ~> Tevun is ready with"
__plot " Your server key is: '${TEVUN_UUID}'"
__plot " Use 'tevun help'"
