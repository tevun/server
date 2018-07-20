#!/bin/bash

BASE=${1}
DOMAIN=${2}
DOMAINS=${BASE}/domains

REPO=${DOMAINS}/${DOMAIN}/repo
APP=${DOMAINS}/${DOMAIN}/app

cd ${APP}

docker-compose down

rm -rf ${REPO}
rm -rf ${APP}

