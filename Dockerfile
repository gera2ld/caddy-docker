ARG CADDY_VERSION=2

FROM caddy:${CADDY_VERSION}-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/alidns \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-security

FROM nginxproxy/docker-gen:latest AS docker-gen

FROM caddy:${CADDY_VERSION}-alpine

VOLUME /data

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=docker-gen /usr/local/bin/docker-gen /usr/bin/docker-gen
COPY docker-gen /docker-gen
COPY entry-point.sh /entry-point.sh

ENTRYPOINT ["/entry-point.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
