#!/bin/sh

if [ -n "$CADDY_DOCKER_GEN" ]; then
  export CADDY_NETWORK=${CADDY_NETWORK:-caddy}

  mkdir -p /etc/docker-gen
  if [ ! -f /etc/docker-gen/docker-gen.conf ]; then
    cp /docker-gen/* /etc/docker-gen/
  fi
  docker-gen -config /etc/docker-gen/docker-gen.conf &
fi

# Run Caddy
exec "$@"
