ARG CADDY_VERSION=2

# Build Caddy-gen

FROM golang:1 AS caddy-gen-builder

WORKDIR /usr/src/app

COPY caddy-gen /usr/src/app/caddy-gen

RUN cd caddy-gen \
    && go mod download \
    && CGO_ENABLED=0 go build -ldflags='-s -w' -trimpath -o /usr/bin/caddy-gen .

# Build Caddy

FROM golang:1 AS caddy-builder

WORKDIR /usr/bin

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@v0.4.4

RUN xcaddy build $CADDY_VERSION \
    # --with github.com/caddy-dns/alidns \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-security \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/fvbommel/caddy-dns-ip-range \
    --with github.com/fvbommel/caddy-combine-ip-ranges \
    --with github.com/mholt/caddy-l4

# Finalize

FROM caddy:${CADDY_VERSION}-alpine
VOLUME /data
WORKDIR /etc/caddy
COPY --from=caddy-gen-builder /usr/bin/caddy-gen /usr/bin/caddy-gen
COPY --from=caddy-builder /usr/bin/caddy /usr/bin/caddy
COPY entry-point.sh /entry-point.sh
ENTRYPOINT ["/entry-point.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
