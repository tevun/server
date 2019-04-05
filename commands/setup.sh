#!/bin/bash

BASE=${1}
TEVUN_USER=1000
if [[ "${2}" ]]; then
  TEVUN_USER=${2}
fi

source ${BASE}/functions.sh

__plot "[1/5] Configure git"
git config --global user.email "setup@tevun.com"
git config --global user.name "Tevun Setup"

__plot "[2/5] Create projects dir in '${BASE}/projects'"
if [[ ! -d "${BASE}/projects" ]];then
  mkdir -p ${BASE}/projects
fi

__plot "[3/5] Configure permissions of projects dir to user: '${TEVUN_USER}'"
chmod 755 ${BASE}/projects
chown ${TEVUN_USER}:${TEVUN_USER} ${BASE}/projects

__plot "[4/5] Create the symlink in '/projects'"
if [[ ! -h "/projects" ]];then
  ln -s ${BASE}/projects /projects
fi

__plot "[5/5] Start docker containers"
cd ${BASE}
docker-compose up -d

__plot "[FINISH] ~> Tevun is ready, use 'tevun help'"
