#!/usr/bin/env bash
set -e -o pipefail

name="server-routing"
dockerImageName='jwilder/nginx-proxy:latest'

docker pull ${dockerImageName}
docker stop ${name} || true
docker rm ${name} || true
docker run \
    --detach \
    --name ${name} \
    --publish 80:80 \
    --publish 443:443 \
    --restart on-failure \
    --volume /etc/nginx/certs \
    --volume /etc/nginx/vhost.d \
    --volume /usr/share/nginx/html \
    --volume /var/run/docker.sock:/tmp/docker.sock:ro \
    ${dockerImageName}

proxyContainerName=${name}
name="server-routing-letsencrypt"
dockerImageName='jrcs/letsencrypt-nginx-proxy-companion'

docker pull ${dockerImageName}
docker stop ${name} || true
docker rm ${name} || true
docker run \
    --detach \
    --name ${name} \
    --volumes-from ${proxyContainerName} \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --env "DEFAULT_EMAIL=krishan@kibalabs.com" \
    ${dockerImageName}
