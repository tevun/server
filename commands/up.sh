#!/bin/bash

BASE=$(dirname $(readlink -f ${0}))
DOMAIN=${1}
APP="${BASE}/app/${DOMAIN}"

cd ${APP}

docker-compose up -d

