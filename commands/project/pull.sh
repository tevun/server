#!/bin/bash

BASE=${1}
PROJECT=${2}

PROJECTS=${BASE}/projects

cd ${PROJECTS}
for f in *; do
  if [[ ! -d ${f} ]]; then
    continue
  fi
  COMPOSE=${PROJECTS}/${f}/app/docker-compose.yml
  if [[ ! -f ${COMPOSE} ]]; then
    continue
  fi
  echo "##### ${f} #####"

  IFS=$'\n'
  var_targets=($(grep "image:" ${PROJECTS}/${f}/app/docker-compose.yml))
  unset IFS

  var_length=${#var_targets[@]}
  for ((i = 0; i != var_length; i++)); do
    var_image="${var_targets[i]}"
    echo "~> ${var_image}"
    var_command=$(echo ${var_image} | sed 's/image\:/docker\ pull/')
    /bin/bash -c "${var_command}"
  done

  cd ${PROJECTS}/${f}/app
  docker-compose down && docker-compose up -d
  cd ${PROJECTS}
done

