#!/bin/bash

BASE=$(dirname $(dirname $(readlink -f ${0})))
DOMAIN=${1}
REPO=${BASE}/${DOMAIN}/repo
APP=${BASE}/${DOMAIN}/app

cd ${APP}

docker-compose down

rm -rf ${REPO}
rm -rf ${APP}

