#!/usr/bin/env bash

cd ${1}

if [ "$(docker ps -q -f name=${1}-app)" ]; then
  docker-compose down
fi

rm -rf ./*
