#!/bin/bash

PROJECT=${2}
SAMPLE=${3}

SAMPLES=${TEVUN_DIR}/samples
PROJECTS=${TEVUN_DIR}/projects

REPO=${PROJECTS}/${PROJECT}/repo
APP=${PROJECTS}/${PROJECT}/app

if [[ ! "${SAMPLE}" ]]; then
  SAMPLE="html"
fi

# CREATE REPO
mkdir -p ${REPO}
__plot "[1/8] Create project repo dir '${REPO}'"
cd ${REPO}
git init --bare > /dev/null
git config --file config http.receivepack true > /dev/null

# CREATE APP
mkdir -p ${APP} > /dev/null
__plot "[2/8] Create project app dir '${APP}'"
cd ${APP}
git init > /dev/null && git remote add origin ${REPO} > /dev/null
__plot "[3/8] Initialize git master remote"
git commit --allow-empty -m "Init" > /dev/null && git push origin master > /dev/null

# CONFIGURE REPO
__plot "[4/8] Configure hooks in repo"
cp -TRv ${SAMPLES}/${SAMPLE}/repo/ ${REPO}/ > /dev/null
find ${REPO}/hooks -type f -exec sed -i "s/{project}/${PROJECT}/g" {} \; > /dev/null
chmod +x ${REPO}/hooks/post-receive > /dev/null

# CONFIGURE APP
__plot "[5/8] Configure app dir"
cp -TRv ${SAMPLES}/${SAMPLE}/app/ ${APP}/ > /dev/null
find ${APP} -type f -exec sed -i "s/{project}/${PROJECT}/g" {} \; > /dev/null

# PREPARE APP
__plot "[6/8] Create setup branch"
git checkout -b setup > /dev/null
git add --all > /dev/null && git commit --allow-empty -m "Setup" > /dev/null

# CONFIGURE SAMPLE
__plot "[7/8] Configure sample project '${SAMPLE}'"
bash ${SAMPLES}/${SAMPLE}/configure.sh ${APP} > /dev/null

# INIT APP
__plot "[8/8] Configure setup branch"
git push origin setup --force > /dev/null
rm -rf ${APP}/.git > /dev/null
rm ${APP}/.tevun-ready > /dev/null

# INFO
__plot "[REMOTE]"
__plot " https://${TEVUN_HOST}:${TEVUN_PORT}/${PROJECT}/repo"
echo " "
__plot "[FINISH] ~> Project '${PROJECT}' created"

