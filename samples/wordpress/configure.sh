#!/usr/bin/env bash

APP_DIR=${1}

#cp ${APP_DIR}/.env.stage ${APP_DIR}/.env
#cp ${APP_DIR}/docker-compose.yml.stage ${APP_DIR}/docker-compose.yml

cd ${APP_DIR}

wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
/bin/rm -rf public
/bin/mv wordpress/ public/
