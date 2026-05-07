#!/usr/bin/env bash

TEVUN_USER_INSTALL=${2}

if [[ ${EUID} -ne 0 ]]; then
  __plot "[ERROR] tevun ssh must run as root (try: sudo tevun ssh ${TEVUN_USER_INSTALL})"
  exit 1
fi

if [[ -z "${TEVUN_USER_INSTALL}" ]]; then
  __plot "[ERROR] usage: tevun ssh <name>"
  exit 1
fi

if ! id -u "${TEVUN_USER_INSTALL}" >/dev/null 2>&1; then
  __plot "[ERROR] user '${TEVUN_USER_INSTALL}' doesn't exist (run: tevun user ${TEVUN_USER_INSTALL})"
  exit 1
fi

TEVUN_KEY_SOURCE_USER="${SUDO_USER:-root}"
TEVUN_KEY_SOURCE_HOME=$(getent passwd "${TEVUN_KEY_SOURCE_USER}" | cut -d: -f6)
TEVUN_KEY_SOURCE="${TEVUN_KEY_SOURCE_HOME}/.ssh/authorized_keys"

if [[ ! -f "${TEVUN_KEY_SOURCE}" ]]; then
  __plot "[ERROR] no authorized_keys at '${TEVUN_KEY_SOURCE}' to copy from"
  exit 1
fi

TEVUN_USER_HOME=$(getent passwd "${TEVUN_USER_INSTALL}" | cut -d: -f6)

__plot "[1/4] Install authorized_keys for '${TEVUN_USER_INSTALL}' (from ${TEVUN_KEY_SOURCE})"
mkdir -p "${TEVUN_USER_HOME}/.ssh"
TEVUN_KEY_DEST="${TEVUN_USER_HOME}/.ssh/authorized_keys"
if [[ "$(readlink -f "${TEVUN_KEY_SOURCE}")" == "$(readlink -f "${TEVUN_KEY_DEST}" 2>/dev/null)" ]]; then
  __plot "  ~> source equals destination, skipping copy"
else
  cp "${TEVUN_KEY_SOURCE}" "${TEVUN_KEY_DEST}"
fi
chmod 700 "${TEVUN_USER_HOME}/.ssh"
chmod 600 "${TEVUN_KEY_DEST}"
chown -R "${TEVUN_USER_INSTALL}:${TEVUN_USER_INSTALL}" "${TEVUN_USER_HOME}/.ssh"

__plot "[2/4] Grant sudo to '${TEVUN_USER_INSTALL}' via /etc/sudoers.d/${TEVUN_USER_INSTALL}"
TEVUN_SUDOERS="/etc/sudoers.d/${TEVUN_USER_INSTALL}"
echo "${TEVUN_USER_INSTALL} ALL=(ALL) ALL" > "${TEVUN_SUDOERS}"
chmod 440 "${TEVUN_SUDOERS}"
if ! visudo -cf "${TEVUN_SUDOERS}" >/dev/null; then
  __plot "[ERROR] invalid sudoers file, removing"
  rm -f "${TEVUN_SUDOERS}"
  exit 1
fi

__plot "[3/4] Disable root SSH login and restrict access to '${TEVUN_USER_INSTALL}'"
TEVUN_SSHD_DROPIN="/etc/ssh/sshd_config.d/99-tevun.conf"
if ! grep -qE "^Include\s+/etc/ssh/sshd_config\.d" /etc/ssh/sshd_config; then
  __plot "[ERROR] /etc/ssh/sshd_config has no Include directive for sshd_config.d/"
  exit 1
fi

TEVUN_ALLOW_USERS="${TEVUN_USER_INSTALL}"
if [[ -f "${TEVUN_SSHD_DROPIN}" ]]; then
  TEVUN_PREV_ALLOW=$(grep -E "^AllowUsers\s" "${TEVUN_SSHD_DROPIN}" | sed -E 's/^AllowUsers\s+//')
  for u in ${TEVUN_PREV_ALLOW}; do
    if [[ "${u}" != "${TEVUN_USER_INSTALL}" ]]; then
      TEVUN_ALLOW_USERS="${TEVUN_ALLOW_USERS} ${u}"
    fi
  done
fi

cat > "${TEVUN_SSHD_DROPIN}" <<EOF
PermitRootLogin no
AllowUsers ${TEVUN_ALLOW_USERS}

Match User root
    PasswordAuthentication no
    PubkeyAuthentication no
    KbdInteractiveAuthentication no
EOF
chmod 644 "${TEVUN_SSHD_DROPIN}"

__plot "[4/4] Validate and reload sshd"
if ! sshd -t; then
  __plot "[ERROR] sshd config invalid, rolling back"
  rm -f "${TEVUN_SSHD_DROPIN}"
  exit 1
fi
systemctl reload ssh 2>/dev/null || systemctl reload sshd 2>/dev/null || service ssh reload

__plot "[FINISH] ~> SSH access policy configured for '${TEVUN_USER_INSTALL}'"
__plot "  Test in a NEW terminal BEFORE closing this session:"
__plot "  ssh ${TEVUN_USER_INSTALL}@<host>"
