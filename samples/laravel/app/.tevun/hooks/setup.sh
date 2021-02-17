#!/usr/bin/env bash

cd "${1}" || exit

echo " ~> [hooks\setup.sh] on [${1}, ${2}]"

# docker exec "{alias}-nginx" php artisan key:generate
