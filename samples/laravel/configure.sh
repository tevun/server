#!/usr/bin/env bash

CONFIGURE_DIR=${1}

cd "${CONFIGURE_DIR}" || exit

CONFIGURE_DIR=${1}
CONFIGURE_PROJECT=${2}

#cp ${APP_DIR}/.env.stage ${APP_DIR}/.env
#cp ${APP_DIR}/docker-compose.yml.stage ${APP_DIR}/docker-compose.yml

alias=$(echo "${CONFIGURE_PROJECT}" | cut -d. -f1)
echo -n "Type an alias to project [${alias}]: "
read -r CONFIGURE_ALIAS
if [[ -z "${CONFIGURE_ALIAS}" ]]; then
  CONFIGURE_ALIAS="${alias}"
fi

CONFIGURE_ROOT="$(date +%s | sha256sum | base64 | head -c 32 ; echo)"
CONFIGURE_PORT="3306"
CONFIGURE_USER="$(date +%s | sha1sum | base64 | head -c 10 ; echo)"
CONFIGURE_PASSWORD="$(date +%s | md5sum | base64 | head -c 32 ; echo)"

# find ${APP} -type f -exec sed -i "s/{project}/${CONFIGURE_PROJECT}/g" {} \; > /dev/null
find "${CONFIGURE_DIR}" -type f -exec sed -i "s/{alias}/${CONFIGURE_ALIAS}/g" {} \; > /dev/null

find "${CONFIGURE_DIR}" -type f -exec sed -i "s/{root}/${CONFIGURE_ROOT}/g" {} \; > /dev/null
find "${CONFIGURE_DIR}" -type f -exec sed -i "s/{port}/${CONFIGURE_PORT}/g" {} \; > /dev/null
find "${CONFIGURE_DIR}" -type f -exec sed -i "s/{database}/${CONFIGURE_ALIAS}/g" {} \; > /dev/null
find "${CONFIGURE_DIR}" -type f -exec sed -i "s/{user}/${CONFIGURE_USER}/g" {} \; > /dev/null
find "${CONFIGURE_DIR}" -type f -exec sed -i "s/{password}/${CONFIGURE_PASSWORD}/g" {} \; > /dev/null

wget -O latest.tar.gz https://codeload.github.com/laravel/laravel/tar.gz/8.x

/bin/tar -xzvf latest.tar.gz  --strip-components 1 -C .
