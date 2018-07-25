#!/bin/bash

BASE=${1}
DOMAIN=${2}

DOMAINS=${BASE}/domains

REPO=${DOMAINS}/${DOMAIN}/repo
APP=${DOMAINS}/${DOMAIN}/app

cd ${APP}

if [ -f "./docker-compose.yml" ]; then
  docker-compose down
fi

rm -rf ${DOMAINS}/${DOMAIN}
