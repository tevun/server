#!/usr/bin/env bash

ACTION=${1}
TEVUN_DIR=$(dirname $(readlink -f ${0}))

cd ${TEVUN_DIR}
source ./tevun-functions.sh

if [[ ! -f .env ]]; then
  cp .env.sample .env
fi
source .env

if [[ ! -f .key ]]; then
  TEVUN_UUID=$(cat /proc/sys/kernel/random/uuid)
  echo ${TEVUN_UUID} > .key
fi
TEVUN_UUID=$(cat .key)

case ${ACTION} in
  "setup")
    source ./commands/setup.sh
  ;;
  "ps")
    source ./commands/utils/ps.sh
  ;;

  "create")
    source ./commands/project/create.sh
  ;;
  "destroy")
    source ./commands/project/destroy.sh
  ;;

  "user")
    source ./commands/credential/user.sh
  ;;
  "ssh")
    source ./commands/credential/ssh.sh
  ;;
  "register")
    source ./commands/credential/register.sh
  ;;

  "lets-encrypt/renew")
    source ./commands/utils/lets-encrypt/renew.sh
  ;;
  "lets-encrypt/status")
    source ./commands/utils/lets-encrypt/status.sh
  ;;

  "ubuntu/locale")
    source ./commands/utils/ubuntu/locale.sh
  ;;
  "requirement")
    INSTALLER="${TEVUN_DIR}/installers/${2}.sh"
    if [[ -f ${INSTALLER} ]];then
      source ${INSTALLER}
    fi
  ;;

#  "start")
#    source ./commands/start.sh ${TEVUN_DIR} ${2}
#  ;;
#  "stop")
#    source ./commands/stop.sh ${TEVUN_DIR} ${2}
#  ;;
#  "up")
#    source ./commands/up.sh ${TEVUN_DIR} ${2}
#  ;;
#  "down")
#    source ./commands/down.sh ${TEVUN_DIR} ${2}
#  ;;
#  "projects")
#    source ./commands/projects.sh ${TEVUN_DIR}
#  ;;
#  "password")
#    source ./commands/utils/password.sh ${TEVUN_DIR}
#  ;;

#  "compose")
#    source ./commands/utils/compose.sh ${TEVUN_DIR} ${2}
#  ;;

  *)
    echo "Usage: tevun COMMAND"
    echo ""
    echo "A project container agile"
    echo ""
    echo "Administrative Commands:"
    echo "setup      Start usage server"
    echo "ps         Show running containers"
    echo "user       Create an user and configure system to use it"
    echo "ssh        Configure ssh with user that will be used to execute the commands"
#    echo "password   Generate a random password"
#    echo "projects    List the projects folder"

    echo ""
    echo "Project Management Commands:"
    echo "create     Create project"
    echo "destroy    Destroy project"
#    echo "start      Apply start on project"
#    echo "stop       Apply stop on project"
#    echo "up         Apply up on project"
#    echo "down       Apply up on project"

    echo ""
    echo "Util Commands:"
    echo "ubuntu/locale         Fix locale on Ubuntu Server"
    echo "lets-encrypt/renew    Force renew certificates"
    echo "lets-encrypt/status   Show certificate status"
    echo "requirement {distro}  Install requirements to your distro [ubuntu, debian, etc]"
    echo ""
  ;;
esac

function __tevun
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="setup password user ps projects \
          create destroy start stop up down \
          ubuntu/locale lets-encrypt/renew lets-encrypt/status requirement \
          help"
    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

complete __tevun tevun
