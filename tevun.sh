#!/usr/bin/env bash

ACTION=${1}
TEVUN_DIR_BIN=$(dirname $(readlink -f ${0}))
TEVUN_DIR_BASE=$(dirname ${TEVUN_DIR_BIN})

case ${ACTION} in
  "setup")
    sh ${TEVUN_DIR_BIN}/commands/setup.sh ${TEVUN_DIR_BASE}
  ;;
  "create")
    sh ${TEVUN_DIR_BIN}/commands/create.sh ${TEVUN_DIR_BASE} ${2} ${3}
  ;;
  "destroy")
    sh ${TEVUN_DIR_BIN}/commands/destroy.sh ${TEVUN_DIR_BASE} ${2}
  ;;
  "start")
    sh ${TEVUN_DIR_BIN}/commands/start.sh ${TEVUN_DIR_BASE} ${2}
  ;;
  "stop")
    sh ${TEVUN_DIR_BIN}/commands/stop.sh ${TEVUN_DIR_BASE} ${2}
  ;;
  "up")
    sh ${TEVUN_DIR_BIN}/commands/up.sh ${TEVUN_DIR_BASE} ${2}
  ;;
  "down")
    sh ${TEVUN_DIR_BIN}/commands/down.sh ${TEVUN_DIR_BASE} ${2}
  ;;
  "password")
    sh ${TEVUN_DIR_BIN}/commands/utils/password.sh ${TEVUN_DIR_BASE}
  ;;
  "user")
    sh ${TEVUN_DIR_BIN}/commands/utils/user.sh ${TEVUN_DIR_BASE} ${2}
  ;;
  "ubuntu/locale")
    sh ${TEVUN_DIR_BIN}/commands/utils/ubuntu/locale.sh ${TEVUN_DIR_BASE}
  ;;
  "requirement")
    INSTALLER="${TEVUN_DIR_BIN}/installers/${2}.sh"
    if [[ -f ${INSTALLER} ]];then
      sh ${INSTALLER}
    fi
  ;;
  *)
  ;;
esac
