#!/usr/bin/env bash

if [ "$(docker ps -q -f name=${1}-app)" ]; then
  docker-compose down
fi