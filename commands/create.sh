#!/bin/bash

BASE=${1}
DOMAIN=${2}
SAMPLE=${3}

SAMPLES=${BASE}/bin/samples
DOMAINS=${BASE}/domains

REPO=${DOMAINS}/${DOMAIN}/repo
APP=${DOMAINS}/${DOMAIN}/app

if [ ! "${SAMPLE}" ];then
  SAMPLE="php"
fi

# REPO
mkdir -p ${REPO}
cd ${REPO}
git init --bare
cp -TRv ${SAMPLES}/${SAMPLE}/repo/ ${REPO}/
find ${REPO}/hooks -type f -exec sed -i "s/{domain}/${DOMAIN}/g" {} \;
chmod +x ${REPO}/hooks/post-receive

# APP
cp -TRv ${SAMPLES}/${SAMPLE}/app/ ${APP}/
cd ${APP}
find ${APP} -type f -exec sed -i "s/{domain}/${DOMAIN}/g" {} \;
if [ -f "./docker-compose.yml" ]; then
  docker-compose up -d
fi

git init && git remote add origin ${REPO}
git commit --allow-empty -m "Init" && git push origin master
git checkout -b setup
git add --all && git commit --allow-empty -m "Setup" && git push origin setup --force
rm -rf ${APP}/.git

# INFO
echo " -- "
echo " ~> git remote add deploy ssh://<user>@<ip>/domains/${DOMAIN}/repo"
echo " "

