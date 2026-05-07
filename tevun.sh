#!/usr/bin/env bash

ACTION=${1}
TEVUN_DIR=$(dirname "$(readlink -f "${0}")")
TEVUN_CONTAINERS_DIR="${TEVUN_DIR}/.docker"

cd "${TEVUN_DIR}" || exit 1
source ./tevun-functions.sh

if [[ ! -f "${TEVUN_CONTAINERS_DIR}/.env" ]]; then
  cp "${TEVUN_CONTAINERS_DIR}/.env.sample" "${TEVUN_CONTAINERS_DIR}/.env"
fi
source "${TEVUN_CONTAINERS_DIR}/.env"

if [[ ! -f "${TEVUN_CONTAINERS_DIR}/.key" ]]; then
  TEVUN_UUID=$(cat /proc/sys/kernel/random/uuid)
  echo "${TEVUN_UUID}" > "${TEVUN_CONTAINERS_DIR}/.key"
fi
TEVUN_UUID=$(cat "${TEVUN_CONTAINERS_DIR}/.key")

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

  "lets-encrypt/renew")
    source ./commands/utils/lets-encrypt/renew.sh
  ;;
  "lets-encrypt/status")
    source ./commands/utils/lets-encrypt/status.sh
  ;;

  "ubuntu/locale")
    source ./commands/utils/ubuntu/locale.sh
  ;;

  "ll")
    source ./commands/project/projects.sh "${TEVUN_DIR}"
  ;;
  "pull")
    source ./commands/project/pull.sh "${TEVUN_DIR}"
  ;;

  *)
    echo "                       ____        ____"
    echo ".___________. ._______.\   \      /   /.__    __. .__   __."
    echo "|           | |   ____| \   \    /   / |  |  |  | |  \ |  |"
    echo "\`---|  |----\` |  |__     \   \  /   /  |  |  |  | |   \|  |"
    echo "    |  |      |   __|     \   \/   /   |  |  |  | |  . \`  |"
    echo "    |  |      |  |____     \      /    |  \`--'  | |  |\   |"
    echo "    |__|      |_______|     \    /      \______/  |__| \__|"
    echo "                             \__/"
    echo "Usage: tevun COMMAND"
    echo ""
    echo "A project container agile"
    echo ""
    echo "Administrative Commands:"
    echo "setup      Start usage server"
    echo "ps         Show running containers"
    echo "user       Create an user and configure system to use it"
    echo "ssh        Configure ssh with user that will be used to execute the commands"
    echo "ll         List the projects folder"
    echo "pull       Pull new images of each project and restart"

    echo ""
    echo "Project Management Commands:"
    echo "create     Create project"
    echo "destroy    Destroy project"

    echo ""
    echo "Util Commands:"
    echo "ubuntu/locale         Fix locale on Ubuntu Server"
    echo "lets-encrypt/renew    Force renew certificates"
    echo "lets-encrypt/status   Show certificate status"
    echo ""
  ;;
esac

function __tevun
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="setup user ssh ps ll pull \
          create destroy \
          ubuntu/locale lets-encrypt/renew lets-encrypt/status \
          help"
    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

complete __tevun tevun
