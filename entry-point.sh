#!/bin/sh

if [ -n "$CADDY_GEN_ENABLED" ]; then
  caddy-gen &
fi

# Run Caddy
exec "$@"
