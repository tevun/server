#!/bin/bash

BASE=$(dirname $(dirname $(readlink -f ${0})))
DOMAIN=${1}
REPO="${BASE}/repo/${DOMAIN}"
APP="${BASE}/app/${DOMAIN}"

cd ${APP}

docker-compose down

rm -rf ${REPO}
rm -rf ${APP}

