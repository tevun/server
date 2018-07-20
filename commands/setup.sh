#!/bin/bash

BASE=${1}

mkdir ${BASE}/domains && chown 775 ${BASE}/domains

docker network create --driver bridge reverse-proxy

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

docker run -d \
    --name nginx-letsencrypt \
    --net reverse-proxy \
    --restart unless-stopped \
    --volumes-from nginx-proxy \
    -v $HOME/certs:/etc/nginx/certs:rw \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    jrcs/letsencrypt-nginx-proxy-companion
