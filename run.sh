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
    server-routing

docker stop server-routing-letsencrypt || true
docker rm server-routing-letsencrypt || true
docker run \
    --detach \
    --name server-routing-letsencrypt \
    --volumes-from server-routing \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --env "DEFAULT_EMAIL=krishan@kibalabs.com" \
    jrcs/letsencrypt-nginx-proxy-companion
