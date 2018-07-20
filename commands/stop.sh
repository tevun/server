#!/bin/bash

BASE=$(dirname $(dirname $(readlink -f ${0})))
DOMAIN=${1}
APP=${BASE}/${DOMAIN}/app

cd ${APP}

docker-compose stop
