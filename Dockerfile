ARG CADDY_VERSION=2
ARG TARGETARCH=amd64

# Build Caddy

FROM golang:1-alpine AS caddy-builder

ARG TARGETARCH

WORKDIR /usr/bin

RUN apk add --update curl

RUN CADDY_GEN_URL=https://github.com/gera2ld/caddy-gen/releases/latest/download/caddy-gen-linux-${TARGETARCH} \
    && echo Download caddy-gen from $CADDY_GEN_URL \
    && curl -fsSLo caddy-gen $CADDY_GEN_URL \
    && chmod +x caddy-gen

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
COPY --from=caddy-builder /usr/bin/caddy-gen /usr/bin/caddy-gen
COPY --from=caddy-builder /usr/bin/caddy /usr/bin/caddy
COPY entry-point.sh /entry-point.sh
ENTRYPOINT ["/entry-point.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
