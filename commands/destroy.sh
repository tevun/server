#!/bin/bash

BASE=${1}
PROJECT=${2}

PROJECTS=${BASE}/projects

REPO=${PROJECTS}/${PROJECT}/repo
APP=${PROJECTS}/${PROJECT}/app

source ${BASE}/functions.sh

if [[ ! -d ${PROJECTS}/${PROJECT} ]]; then
  __plot "[FINISH] ~> Project '${PROJECT}' doesn't exists"
  exit 0
fi

cd ${APP}

__plot "[1/1] Destroy '${PROJECT}' (${PROJECTS}/${PROJECT})?"
echo -n " y/n: "
read DESTROY
TEVUN_MESSAGE="The project '${PROJECT}' was not destroyed"
if [[ ${DESTROY} = "y" ]]; then
  if [[ -f "./docker-compose.yml" ]]; then
    docker-compose down
    docker-compose rm -f
  fi
  rm -rf ${PROJECTS}/${PROJECT}
  TEVUN_MESSAGE="Project '${PROJECT}' destroyed"
fi
__plot "[FINISH] ~> ${TEVUN_MESSAGE}"
