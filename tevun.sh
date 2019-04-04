#!/usr/bin/env bash

ACTION=${1}
TEVUN_DIR_BIN=$(dirname $(readlink -f ${0}))
TEVUN_DIR_BASE=$(dirname ${TEVUN_DIR_BIN})

case ${ACTION} in
  "setup")
    sh ${TEVUN_DIR_BIN}/commands/setup.sh ${TEVUN_DIR_BASE} ${2}
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
  "domains")
    sh ${TEVUN_DIR_BIN}/commands/domains.sh ${TEVUN_DIR_BASE}
  ;;
  "password")
    sh ${TEVUN_DIR_BIN}/commands/utils/password.sh ${TEVUN_DIR_BASE}
  ;;
  "user")
    sh ${TEVUN_DIR_BIN}/commands/utils/user.sh ${TEVUN_DIR_BASE} ${2}
  ;;
  "ssh")
    sh ${TEVUN_DIR_BIN}/commands/utils/ssh.sh ${TEVUN_DIR_BASE} ${2}
  ;;
  "compose")
    sh ${TEVUN_DIR_BIN}/commands/utils/compose.sh ${TEVUN_DIR_BASE} ${2}
  ;;
  "ubuntu/locale")
    sh ${TEVUN_DIR_BIN}/commands/utils/ubuntu/locale.sh ${TEVUN_DIR_BASE}
  ;;
  "lets-encrypt/renew")
    sh ${TEVUN_DIR_BIN}/commands/utils/lets-encrypt/renew.sh ${TEVUN_DIR_BASE}
  ;;
  "lets-encrypt/status")
    sh ${TEVUN_DIR_BIN}/commands/utils/lets-encrypt/status.sh ${TEVUN_DIR_BASE}
  ;;
  "ps")
    sh ${TEVUN_DIR_BIN}/commands/utils/ps.sh ${TEVUN_DIR_BASE}
  ;;
  "requirement")
    INSTALLER="${TEVUN_DIR_BIN}/installers/${2}.sh"
    if [[ -f ${INSTALLER} ]];then
      sh ${INSTALLER}
    fi
  ;;
  *)
    echo "Usage: tevun COMMAND"
    echo ""
    echo "A domain container agile"
    echo ""
    echo "Administrative Commands:"
    echo "setup      Start usage server"
    echo "password   Generate a random password"
    echo "user       Create a user"
    echo "ssh        Setup ssh to user used to run the commands"
    echo "ps         Show running containers"
    echo "domains    List the domains folder"

    echo ""
    echo "Domain Management Commands:"
    echo "create     Create domain"
    echo "destroy    Destroy domain"
    echo "start      Apply start on domain"
    echo "stop       Apply stop on domain"
    echo "up         Apply up on domain"
    echo "down       Apply up on domain"

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
    opts="setup password user ps domains \
          create destroy start stop up down \
          ubuntu/locale lets-encrypt/renew lets-encrypt/status requirement \
          help"
    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

complete __tevun tevun
