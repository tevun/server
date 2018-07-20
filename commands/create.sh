#!/bin/bash

BASE=${1}
DOMAIN=${2}
SAMPLE=${3}

SAMPLES=${BASE}/samples
DOMAINS=${BASE}/domains

REPO=${DOMAINS}/${DOMAIN}/repo
APP=${DOMAINS}/${DOMAIN}/app

if [[ ! "${SAMPLE}" ]];then
  SAMPLE="php"
fi

# REPO
mkdir -p ${REPO}
cd ${REPO}
git init --bare
cp -TRv ${SAMPLES}/${SAMPLE}/repo/ ${REPO}/hooks/
find ${REPO}/hooks -type f -exec sed -i "s/{domain}/${DOMAIN}/g" {} \;
chmod +x ${REPO}/hooks/post-receive

# APP
cp -TRv ${SAMPLES}/${SAMPLE}/app/ ${APP}/
cd ${APP}
find ${APP} -type f -exec sed -i "s/{domain}/${DOMAIN}/g" {} \;
docker-compose up -d

# INFO
echo " -- "
echo " ~> git remote add deploy ssh://root@<ip>${REPO}"
echo " "

