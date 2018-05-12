#!/bin/bash

BASE=$(dirname $(readlink -f ${0}))
DOMAIN=${1}
REPO="${BASE}/repo/${DOMAIN}"
APP="${BASE}/app/${DOMAIN}"

mkdir -p ${REPO}
mkdir -p "${APP}/public"

cd ${REPO}

git init --bare

cp "${BASE}/samples/post-receive" "${REPO}/hooks/post-receive"
cp "${BASE}/samples/docker-compose.yml" "${APP}/docker-compose.yml"
cp "${BASE}/samples/index.html" "${APP}/public/index.html"

sed -i "s/{domain}/${DOMAIN}/g" "${APP}/docker-compose.yml"
sed -i "s/{domain}/${DOMAIN}/g" "${APP}/public/index.html"

chmod +x "${REPO}/hooks/post-receive"

cd ${APP}

docker-compose up -d

echo " --- docker"
cat "${APP}/docker-compose.yml"
echo " "
echo " --- git"
echo " ~> ssh://root@<ip>/~/repo/${DOMAIN}"
echo " "

