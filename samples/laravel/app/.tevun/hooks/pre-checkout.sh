#!/usr/bin/env bash

cd "${1}" || exit

echo " ~> [hooks\pre-checkout.sh] on [${1}, ${2}]"

if [[ "$(docker ps -q -f name={alias}-nginx)" ]]; then
  docker-compose down
fi
