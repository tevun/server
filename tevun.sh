#!/usr/bin/env bash

ACTION=${1}
DIR_NAME=$(dirname $(readlink -f ${0}))

case ${ACTION} in
  "setup")
    sh ${DIR_NAME}/commands/setup.sh
  ;;
  "create")
    sh ${DIR_NAME}/commands/create.sh ${2}
  ;;
  "destroy")
    sh ${DIR_NAME}/commands/destroy.sh ${2}
  ;;
  "start")
    sh ${DIR_NAME}/commands/start.sh ${2}
  ;;
  "stop")
    sh ${DIR_NAME}/commands/stop.sh ${2}
  ;;
  "password")
    sh ${DIR_NAME}/commands/utils/password.sh
  ;;
  "requirement")
    INSTALLER="${DIR_NAME}/installers/${2}.sh"
    if [[ -f ${INSTALLER} ]];then
      sh ${INSTALLER}
    fi
  ;;
  *)
  ;;
esac

