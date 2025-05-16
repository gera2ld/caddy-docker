ARG CADDY_VERSION=2
ARG TARGETARCH=amd64

# Download caddy-gen

FROM alpine AS downloader
ARG TARGETARCH
WORKDIR /usr/bin
ADD https://github.com/gera2ld/caddy-gen/releases/latest/download/caddy-gen-linux-${TARGETARCH} caddy-gen
ADD bin/caddy-linux-${TARGETARCH} caddy
RUN chmod +x caddy caddy-gen

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
