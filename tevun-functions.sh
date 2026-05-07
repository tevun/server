#!/usr/bin/env bash

function __plot
{
  printf "\033[0;32m${1}\033[0m \n"
}

function __has_docker
{
  command -v docker >/dev/null 2>&1
}

function __has_docker_compose
{
  __has_docker && docker compose version >/dev/null 2>&1
}

function __require_docker
{
  if ! __has_docker; then
    __plot "[ERROR] Docker is not installed (https://docs.docker.com/engine/install/)"
    exit 1
  fi
}

function __require_docker_compose
{
  __require_docker
  if ! docker compose version >/dev/null 2>&1; then
    __plot "[ERROR] Docker Compose v2 plugin not found (try: docker compose version)"
    exit 1
  fi
}