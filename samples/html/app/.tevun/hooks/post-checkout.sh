#!/usr/bin/env bash

if [ -f "docker-compose.yml" ]; then
  docker-compose rm
  docker-compose up -d
fi