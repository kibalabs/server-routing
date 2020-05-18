#!/usr/bin/env bash
set -e -o pipefail

docker build -t server-routing src/
docker stop server-routing || true
docker rm server-routing || true
docker run \
    --detach \
    --name server-routing \
    --publish 80:80 \
    --publish 443:443 \
    --restart on-failure \
    --volume /etc/nginx/certs \
    --volume /etc/nginx/vhost.d \
    --volume /usr/share/nginx/html \
    --volume /var/run/docker.sock:/tmp/docker.sock:ro \
    --env DEFAULT_HOST=certs.kiba.dev \
    jwilder/nginx-proxy:latest
