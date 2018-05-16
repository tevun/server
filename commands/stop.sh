#!/bin/bash

BASE=$(dirname $(dirname $(readlink -f ${0})))
DOMAIN=${1}
APP="${BASE}/app/${DOMAIN}"

cd ${APP}

docker-compose stop

