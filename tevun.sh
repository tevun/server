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
  "live")
    sh ${DIR_NAME}/commands/live.sh ${2}
  ;;
  "die")
    sh ${DIR_NAME}/commands/die.sh ${2}
  ;;
  "password")
    sh ${DIR_NAME}/commands/utils/password.sh
  ;;
  *)
  ;;
esac