#!/usr/bin/env bash

cd ${1}

if [ "$(docker ps -q -f name=${2}-app)" ]; then
  docker-compose down
fi

# rm -rf ./*
