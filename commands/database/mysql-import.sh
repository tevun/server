#!/usr/bin/env bash

# docker run -it -v $(pwd):/dump mysql:5.6 bash

mysql -f -h ${TEVUN_HOST} -u ${TEVUN_USER} -p ${TEVUN_DATABASE} < ${TEVUN_FILE}