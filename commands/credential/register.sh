#!/bin/bash

__plot "[1/2] Type the username of new user: "
read NEW_USER

__plot "[2/2] Type the password of new user: "
docker exec -it tevun htpasswd -c /etc/nginx/.users ${NEW_USER}

__plot "[FINISH] ~> New user '${NEW_USER}' created"
