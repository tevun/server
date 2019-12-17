#!/usr/bin/env bash

docker build -t tevun/server:aws-${1} .

docker tag tevun/server:aws-${1} tevun/server:aws-${1}
docker push tevun/server:aws-${1}

docker tag tevun/server:aws-${1} tevun/server:aws-latest
docker push tevun/server:aws-latest
