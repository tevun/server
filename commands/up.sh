#!/bin/bash

BASE=$(dirname $(dirname $(readlink -f ${0})))
PROJECT=${1}
APP=${BASE}/${PROJECT}/app

cd ${APP}

docker-compose up -d
