#!/usr/bin/env bash

TEVUN_DATABASE=${1}
TEVUN_USER="root"
TABLES="SELECT table_name FROM tables WHERE table_type = 'BASE TABLE' AND table_schema = '${TEVUN_DATABASE}'"

mysql INFORMATION_SCHEMA\
 --skip-column-names\
 --batch -e ${TABLES} | xargs mysqldump -u ${TEVUN_USER} -p ${TEVUN_DATABASE} > $(date).sql
