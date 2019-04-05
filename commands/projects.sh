#!/bin/bash

BASE=${1}
PROJECT=${2}

PROJECTS=${BASE}/projects

ls -lah ${PROJECTS} --color | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/) \
             *2^(8-i));if(k)printf("%0o ",k);print}'
