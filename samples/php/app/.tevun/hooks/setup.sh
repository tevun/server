#!/usr/bin/env bash

#cd ${1}

cp .env.stage .env
cp docker-compose.yml.stage docker-compose.yml

#docker exec {container} php artisan key:generate
