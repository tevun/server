#!/bin/bash

PROJECT=${2}
PROJECTS=${TEVUN_DIR}/projects

APP=${PROJECTS}/${PROJECT}/app

source "${TEVUN_DIR}/tevun-functions.sh"

if [[ ! -d ${PROJECTS}/${PROJECT} ]]; then
  __plot "[FINISH] ~> Project '${PROJECT}' doesn't exists"
  exit 0
fi

__plot "[1/1] Destroy '${PROJECT}' (${PROJECTS}/${PROJECT})? yes/[N]: "
read -r DESTROY

TEVUN_MESSAGE="The project '${PROJECT}' was not destroyed"
if [[ ${DESTROY} = "yes" ]]; then
  cd "${APP}" || exit
  if [[ -f "docker-compose.yml" ]]; then
    docker-compose down --volumes
    docker-compose rm -f -v
  fi
  rm -rf "${PROJECTS:?}/${PROJECT}"
  TEVUN_MESSAGE="Project '${PROJECT}' destroyed"
fi
__plot "[FINISH] ~> ${TEVUN_MESSAGE}"
