ARG CADDY_VERSION=2

# Build Caddy-gen

FROM golang:1-alpine AS caddy-gen-builder

WORKDIR /usr/src/app

COPY caddy-gen /usr/src/app/caddy-gen

RUN cd caddy-gen \
    && go mod download \
    && CGO_ENABLED=0 go build -ldflags='-s -w' -trimpath -o /usr/bin/caddy-gen .

# Build Caddy

FROM caddy:${CADDY_VERSION}-builder-alpine AS caddy-builder

RUN xcaddy build \
    --with github.com/caddy-dns/alidns \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-security \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/fvbommel/caddy-dns-ip-range \
    --with github.com/fvbommel/caddy-combine-ip-ranges

# Finalize

FROM caddy:${CADDY_VERSION}-alpine
VOLUME /data
WORKDIR /etc/caddy
COPY --from=caddy-gen-builder /usr/bin/caddy-gen /usr/bin/caddy-gen
COPY --from=caddy-builder /usr/bin/caddy /usr/bin/caddy
COPY entry-point.sh /entry-point.sh
ENTRYPOINT ["/entry-point.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
