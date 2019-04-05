#!/usr/bin/env bash

ACTION=${1}
TEVUN_DIR_BIN=$(dirname $(readlink -f ${0}))

case ${ACTION} in
  "setup")
    bash ${TEVUN_DIR_BIN}/commands/setup.sh ${TEVUN_DIR_BIN} ${2}
  ;;
  "create")
    bash ${TEVUN_DIR_BIN}/commands/create.sh ${TEVUN_DIR_BIN} ${2} ${3}
  ;;
  "destroy")
    bash ${TEVUN_DIR_BIN}/commands/destroy.sh ${TEVUN_DIR_BIN} ${2}
  ;;
  "start")
    bash ${TEVUN_DIR_BIN}/commands/start.sh ${TEVUN_DIR_BIN} ${2}
  ;;
  "stop")
    bash ${TEVUN_DIR_BIN}/commands/stop.sh ${TEVUN_DIR_BIN} ${2}
  ;;
  "up")
    bash ${TEVUN_DIR_BIN}/commands/up.sh ${TEVUN_DIR_BIN} ${2}
  ;;
  "down")
    bash ${TEVUN_DIR_BIN}/commands/down.sh ${TEVUN_DIR_BIN} ${2}
  ;;
  "projects")
    bash ${TEVUN_DIR_BIN}/commands/projects.sh ${TEVUN_DIR_BIN}
  ;;
  "password")
    bash ${TEVUN_DIR_BIN}/commands/utils/password.sh ${TEVUN_DIR_BIN}
  ;;
  "user")
    bash ${TEVUN_DIR_BIN}/commands/utils/user.sh ${TEVUN_DIR_BIN} ${2}
  ;;
  "ssh")
    bash ${TEVUN_DIR_BIN}/commands/utils/ssh.sh ${TEVUN_DIR_BIN} ${2}
  ;;
  "compose")
    bash ${TEVUN_DIR_BIN}/commands/utils/compose.sh ${TEVUN_DIR_BIN} ${2}
  ;;
  "ubuntu/locale")
    bash ${TEVUN_DIR_BIN}/commands/utils/ubuntu/locale.sh ${TEVUN_DIR_BIN}
  ;;
  "lets-encrypt/renew")
    bash ${TEVUN_DIR_BIN}/commands/utils/lets-encrypt/renew.sh ${TEVUN_DIR_BIN}
  ;;
  "lets-encrypt/status")
    bash ${TEVUN_DIR_BIN}/commands/utils/lets-encrypt/status.sh ${TEVUN_DIR_BIN}
  ;;
  "ps")
    bash ${TEVUN_DIR_BIN}/commands/utils/ps.sh ${TEVUN_DIR_BIN}
  ;;
  "requirement")
    INSTALLER="${TEVUN_DIR_BIN}/installers/${2}.sh"
    if [[ -f ${INSTALLER} ]];then
      bash ${INSTALLER}
    fi
  ;;
  *)
    echo "Usage: tevun COMMAND"
    echo ""
    echo "A project container agile"
    echo ""
    echo "Administrative Commands:"
    echo "setup      Start usage server"
    echo "password   Generate a random password"
    echo "user       Create a user"
    echo "ssh        Setup ssh to user used to run the commands"
    echo "ps         Show running containers"
    echo "projects    List the projects folder"

    echo ""
    echo "Project Management Commands:"
    echo "create     Create project"
    echo "destroy    Destroy project"
    echo "start      Apply start on project"
    echo "stop       Apply stop on project"
    echo "up         Apply up on project"
    echo "down       Apply up on project"

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
