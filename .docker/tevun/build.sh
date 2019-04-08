#!/usr/bin/env bash

docker build -t tevun/server .
docker tag tevun/server tevun/server:${1}
docker push tevun/server:${1}
docker push tevun/server:latest