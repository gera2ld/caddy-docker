ARG CADDY_VERSION=2

FROM caddy:${CADDY_VERSION}-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/alidns \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-security \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/fvbommel/caddy-dns-ip-range \
    --with github.com/fvbommel/caddy-combine-ip-ranges

FROM caddy:${CADDY_VERSION}-alpine

VOLUME /data

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
