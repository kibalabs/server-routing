#!/usr/bin/env bash
set -e -o pipefail

docker network create server-routing || true

docker build -t server-routing src/
docker stop server-routing || true
docker rm server-routing || true
containerId=$(docker run \
    --detach \
    --name server-routing \
    --publish 80:80 \
    --network server-routing \
    server-routing
)
docker logs -f $containerId
