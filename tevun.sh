#!/usr/bin/env bash

ACTION=${1}
TEVUN_DIR_NAME=$(dirname $(readlink -f ${0}))

case ${ACTION} in
  "setup")
    sh ${TEVUN_DIR_NAME}/commands/setup.sh ${TEVUN_DIR_NAME}
  ;;
  "create")
    sh ${TEVUN_DIR_NAME}/commands/create.sh ${TEVUN_DIR_NAME} ${2} ${3}
  ;;
  "destroy")
    sh ${TEVUN_DIR_NAME}/commands/destroy.sh ${TEVUN_DIR_NAME} ${2}
  ;;
  "start")
    sh ${TEVUN_DIR_NAME}/commands/start.sh ${TEVUN_DIR_NAME} ${2}
  ;;
  "stop")
    sh ${TEVUN_DIR_NAME}/commands/stop.sh ${TEVUN_DIR_NAME} ${2}
  ;;
  "up")
    sh ${TEVUN_DIR_NAME}/commands/up.sh ${TEVUN_DIR_NAME} ${2}
  ;;
  "down")
    sh ${TEVUN_DIR_NAME}/commands/down.sh ${TEVUN_DIR_NAME} ${2}
  ;;
  "password")
    sh ${TEVUN_DIR_NAME}/commands/utils/password.sh ${TEVUN_DIR_NAME}
  ;;
  "user")
    sh ${TEVUN_DIR_NAME}/commands/utils/user.sh ${TEVUN_DIR_NAME} ${2}
  ;;
  "ubuntu/locale")
    sh ${TEVUN_DIR_NAME}/commands/utils/ubuntu/locale.sh ${TEVUN_DIR_NAME}
  ;;
  "requirement")
    INSTALLER="${TEVUN_DIR_NAME}/installers/${2}.sh"
    if [[ -f ${INSTALLER} ]];then
      sh ${INSTALLER}
    fi
  ;;
  *)
  ;;
esac
