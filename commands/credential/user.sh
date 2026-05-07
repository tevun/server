#!/usr/bin/env bash

TEVUN_USER_INSTALL=${2}

if [[ ${EUID} -ne 0 ]]; then
  __plot "[ERROR] tevun user must run as root (try: sudo tevun user ${TEVUN_USER_INSTALL})"
  exit 1
fi

if [[ -z "${TEVUN_USER_INSTALL}" ]]; then
  __plot "[ERROR] usage: tevun user <name>"
  exit 1
fi

__plot "[1/2] Create user '${TEVUN_USER_INSTALL}'"
if id -u "${TEVUN_USER_INSTALL}" >/dev/null 2>&1; then
  __plot "  ~> already exists, skipping"
else
  useradd --create-home --shell /bin/bash "${TEVUN_USER_INSTALL}"
fi

__plot "[2/2] Add '${TEVUN_USER_INSTALL}' to 'sudo' and 'docker' groups"
usermod -aG sudo "${TEVUN_USER_INSTALL}"
if getent group docker >/dev/null 2>&1; then
  usermod -aG docker "${TEVUN_USER_INSTALL}"
else
  __plot "  ~> 'docker' group not found, skipping (re-run after installing Docker)"
fi

__plot "[FINISH] ~> User '${TEVUN_USER_INSTALL}' ready (set a password with: passwd ${TEVUN_USER_INSTALL})"
