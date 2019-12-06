#!/bin/bash

BASE=${1}
PROJECT=${2}

PROJECTS=${BASE}/projects

cd ${PROJECTS}
for f in *; do
  if [[ ! -d ${f} ]]; then
    continue
  fi
  echo ${f}
done
