ARG CADDY_VERSION=2

# Download caddy-gen

FROM alpine AS downloader
ARG TARGETARCH
WORKDIR /usr/bin
ADD --chmod=0755 https://github.com/gera2ld/caddy-gen/releases/latest/download/caddy-gen-linux-${TARGETARCH} caddy-gen
COPY --chmod=0755 bin/caddy-linux-${TARGETARCH} caddy

# Finalize

FROM caddy:${CADDY_VERSION}-alpine
ARG TARGETARCH
VOLUME /data
WORKDIR /etc/caddy
COPY --from=downloader /usr/bin/caddy-gen /usr/bin/caddy-gen
COPY --from=downloader /usr/bin/caddy /usr/bin/caddy
ADD entry-point.sh /entry-point.sh
ENTRYPOINT ["/entry-point.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
