#!/bin/bash

BASE=${1}
TEVUN_USER=1000
if [ "${2}" ]; then
  TEVUN_USER=${2}
fi

git config --global user.email "setup@tevun.com"
git config --global user.name "Tevun Setup"

if [ ! -d "${BASE}/domains}" ];then
  mkdir -p ${BASE}/domains
fi
chmod 755 ${BASE}/domains
chown ${TEVUN_USER}:docker ${BASE}/domains
if [ ! -L "/domains}" ];then
  ln -s ${BASE}/domains /domains
fi

NETWORK_EXISTS=$(docker network ls -q -f name=reverse-proxy)
if [ ! "${NETWORK_EXISTS}" ];then
  docker network create --driver bridge reverse-proxy
fi

OLD_CONTAINER=$(docker ps -q -f name=nginx-proxy)
if [ "${OLD_CONTAINER}" ]; then
  docker rm ${OLD_CONTAINER}
fi
docker run -d -p 80:80 -p 443:443 \
    --name nginx-proxy \
    --net reverse-proxy \
    --restart unless-stopped \
    -v $HOME/certs:/etc/nginx/certs:ro \
    -v /etc/nginx/vhost.d \
    -v /usr/share/nginx/html \
    -v /var/run/docker.sock:/tmp/docker.sock:ro \
    --label com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy=true \
    jwilder/nginx-proxy

OLD_CONTAINER=$(docker ps -q -f name=nginx-letsencrypt)
if [ "${OLD_CONTAINER}" ]; then
  docker rm ${OLD_CONTAINER}
fi
docker run -d \
    --name nginx-letsencrypt \
    --net reverse-proxy \
    --restart unless-stopped \
    --volumes-from nginx-proxy \
    -v $HOME/certs:/etc/nginx/certs:rw \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    jrcs/letsencrypt-nginx-proxy-companion
