#!/bin/bash

BASE=$(dirname $(dirname $(readlink -f ${0})))
DOMAIN=${1}
SAMPLE=${2}
REPO=${BASE}/${DOMAIN}/repo
APP=${BASE}/${DOMAIN}/app

if [[ ! ${SAMPLE} ]];then
  SAMPLE="php"
fi

# REPO
mkdir -p ${REPO}
cd ${REPO}
git init --bare
cp ${BASE}/samples/${SAMPLE}/repo/post-receive ${REPO}/hooks/post-receive
find ${REPO}/hooks -type f -exec sed -i "s/{domain}/${DOMAIN}/g" {} \;
chmod +x ${REPO}/hooks/post-receive

# APP
cp -TRv ${BASE}/samples/${SAMPLE}/ ${APP}/
cd ${APP}
find ${APP} -type f -exec sed -i "s/{domain}/${DOMAIN}/g" {} \;
docker-compose up -d

# INFO
echo " -- "
echo " ~> ssh://root@<ip>/~/repo/${DOMAIN}"
echo " "

