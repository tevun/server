#!/usr/bin/env bash

cd ${1}

if [ -f "docker-compose.yml" ]; then
  docker-compose rm
  docker-compose up -d
fi
