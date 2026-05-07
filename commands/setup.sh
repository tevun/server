#!/bin/bash

if [[ $EUID -ne 0 ]] && [[ ! -w "${TEVUN_DIR}" ]]; then
  echo "Setup requires write access to ${TEVUN_DIR}. Run with: sudo tevun setup" >&2
  exit 1
fi

INTERACTIVE=true
for arg in "$@"; do
  if [[ "$arg" == "--quiet" ]]; then
    INTERACTIVE=false
    break
  fi
done

if [[ -n "${SUDO_USER}" ]]; then
  TEVUN_USER_NAME="${SUDO_USER}"
else
  TEVUN_USER_NAME=$(id -u -n)
fi
TEVUN_USER_GROUP=$(id -gn "${TEVUN_USER_NAME}")

__plot "[1/7] Configure git"
cd "${TEVUN_DIR}" || exit 1

if ! git config --system --get-all safe.directory 2>/dev/null | grep -qx "${TEVUN_DIR}"; then
  git config --system --add safe.directory "${TEVUN_DIR}"
fi

if [[ -z "$(git config --local --get user.name)" ]]; then
  git config --local user.name "${TEVUN_USER_NAME}"
fi

TEVUN_USER_EMAIL=$(git config --local --get user.email)
if [[ -z "${TEVUN_USER_EMAIL}" ]]; then
  if $INTERACTIVE; then
    echo -n " Git user email? "
    read -r TEVUN_USER_EMAIL
  fi
  TEVUN_USER_EMAIL=${TEVUN_USER_EMAIL:-"setup@tevun.com"}
  git config --local user.email "${TEVUN_USER_EMAIL}"
fi

TEVUN_DEFAULT_BRANCH=$(git config --local --get init.defaultBranch)
if [[ -z "${TEVUN_DEFAULT_BRANCH}" ]]; then
  if $INTERACTIVE; then
    echo -n " Git default branch? [main] "
    read -r TEVUN_DEFAULT_BRANCH
  fi
  TEVUN_DEFAULT_BRANCH=${TEVUN_DEFAULT_BRANCH:-main}
  git config --local init.defaultBranch "${TEVUN_DEFAULT_BRANCH}"
fi

__plot "[2/7] Define env properties in '${TEVUN_CONTAINERS_DIR}/.env'"
cd "${TEVUN_CONTAINERS_DIR}" || exit 1
cp .env.sample .env

DEFAULT_HOST=$(curl -4 -s --max-time 3 icanhazip.com 2>/dev/null || echo "localhost")
TEVUN_HOST="${DEFAULT_HOST}"
if $INTERACTIVE; then
  echo -n " Host? (IP or FQDN) [${DEFAULT_HOST}]: "
  read -r INPUT_HOST
  TEVUN_HOST=${INPUT_HOST:-${DEFAULT_HOST}}
fi

DEFAULT_SSH_PORT=$(grep -E "^Port|^#Port" /etc/ssh/sshd_config 2>/dev/null | head -1 | awk '{print $2}')
DEFAULT_SSH_PORT=${DEFAULT_SSH_PORT:-22}
TEVUN_PORT_SSH="${DEFAULT_SSH_PORT}"
if $INTERACTIVE; then
  echo -n " SSH port? [${DEFAULT_SSH_PORT}]: "
  read -r INPUT_SSH
  TEVUN_PORT_SSH=${INPUT_SSH:-${DEFAULT_SSH_PORT}}
fi

sed -i "s|{TEVUN_DEFAULT_BRANCH}|${TEVUN_DEFAULT_BRANCH}|g" .env
sed -i "s|{TEVUN_USER_EMAIL}|${TEVUN_USER_EMAIL}|g" .env
sed -i "s|{TEVUN_USER_NAME}|${TEVUN_USER_NAME}|g" .env
sed -i "s|{TEVUN_USER_GROUP}|${TEVUN_USER_GROUP}|g" .env
sed -i "s|{TEVUN_HOST}|${TEVUN_HOST}|g" .env
sed -i "s|{TEVUN_PORT_SSH}|${TEVUN_PORT_SSH}|g" .env

chown "${TEVUN_USER_NAME}:${TEVUN_USER_GROUP}" .env

__plot "[3/7] Create projects dir at '${TEVUN_DIR}/projects'"
mkdir -p "${TEVUN_DIR}/projects"
chown "${TEVUN_USER_NAME}:${TEVUN_USER_GROUP}" "${TEVUN_DIR}/projects"
chmod 755 "${TEVUN_DIR}/projects"

__plot "[4/7] Symlink '/projects' → '${TEVUN_DIR}/projects'"
if [[ ! -h /projects ]]; then
  ln -s "${TEVUN_DIR}/projects" /projects
fi

__plot "[5/7] Generate '${TEVUN_CONTAINERS_DIR}/docker-compose.yml'"
if [[ ! -f "${TEVUN_CONTAINERS_DIR}/docker-compose.yml" ]]; then
  cp "${TEVUN_CONTAINERS_DIR}/docker-compose.yml.sample" "${TEVUN_CONTAINERS_DIR}/docker-compose.yml"
  chown "${TEVUN_USER_NAME}:${TEVUN_USER_GROUP}" "${TEVUN_CONTAINERS_DIR}/docker-compose.yml"
fi

if ! __has_docker_compose; then
  __plot "[6/7] Skipping docker network (Docker/Compose v2 not installed yet)"
  __plot "[7/7] Skipping container start (Docker/Compose v2 not installed yet)"
  __plot "[FINISH] ~> Tevun files are ready, but Docker isn't installed."
  __plot " Install Docker (https://docs.docker.com/engine/install/) and re-run: sudo tevun setup"
  exit 0
fi

__plot "[6/7] Ensure 'reverse-proxy' docker network"
if ! docker network ls --format '{{.Name}}' | grep -qx reverse-proxy; then
  docker network create --driver bridge reverse-proxy
fi

__plot "[7/7] Start docker containers"
cd "${TEVUN_CONTAINERS_DIR}" || exit 1
docker compose down --remove-orphans 2>/dev/null
docker compose up -d

__plot "[FINISH] ~> Tevun is ready"
__plot " Server key: '${TEVUN_UUID}'"
__plot " Try: tevun help"
