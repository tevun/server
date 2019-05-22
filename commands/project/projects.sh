#!/bin/bash

BASE=${1}
PROJECT=${2}

PROJECTS=${BASE}/projects

ls -lah ${PROJECTS} --color | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/) \
             *2^(8-i));if(k)printf("%0o ",k);print}'

#TEVUN_RESULTS=($(mysql -Bse "SELECT a, b, c, d FROM projects;"))
#TEVUN_RESULTS_TOTAL=${#TEVUN_RESULTS[@]}
#for (( i=0 ; i<${TEVUN_RESULTS_TOTAL} ; i++ ))
#do
#    echo "Record No. $i: ${TEVUN_RESULTS[$i]}"
#    fieldA=${TEVUN_RESULTS[0]};
#    fieldB=${TEVUN_RESULTS[1]};
#    fieldC=${TEVUN_RESULTS[2]};
#    fieldD=${TEVUN_RESULTS[3]};
#done
