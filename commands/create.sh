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

# CREATE REPO
mkdir -p ${REPO}
cd ${REPO}
git init --bare

# CREATE APP
mkdir -p ${APP}
cd ${APP}
git init && git remote add origin ${REPO}
git commit --allow-empty -m "Init" && git push origin master

# CONFIGURE REPO
cp -TRv ${SAMPLES}/${SAMPLE}/repo/ ${REPO}/
find ${REPO}/hooks -type f -exec sed -i "s/{domain}/${DOMAIN}/g" {} \;
chmod +x ${REPO}/hooks/post-receive

# CONFIGURE APP
cp -TRv ${SAMPLES}/${SAMPLE}/app/ ${APP}/
find ${APP} -type f -exec sed -i "s/{domain}/${DOMAIN}/g" {} \;

# PREPARE APP
git checkout -b setup
git add --all && git commit --allow-empty -m "Setup"

# CONFIGURE SAMPLE
sh ${SAMPLES}/${SAMPLE}/configure.sh ${APP}

# INIT APP
git push origin setup --force
rm -rf ${APP}/.git
rm ${APP}/.ready

# INFO
echo " -- "
echo " ~> git remote add deploy ssh://<user>@<ip>/domains/${DOMAIN}/repo"
echo " "

