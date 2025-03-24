# caddy

This is an unofficial build for caddy, with additional features:

- DNS challenge for SSL
- Add Cloudflare IP ranges to trusted proxies
- Caddy Gen to generate configuration automatically when a service is up or down

## Build

```bash
$ docker build -t caddy .
```

## Usage

```yaml
services:
  caddy:
    image: gera2ld/caddy:latest
    restart: always
    ports:
      - 80:80
      - 443:443
      - 443:443/udp
    volumes:
      - caddy_data:/data
      - ./site:/srv
      - ./caddy:/etc/caddy

      # Needed by caddy-gen
      - /var/run/docker.sock:/var/run/docker.sock

    environment:

      # Needed by caddy-gen
      - CADDY_GEN_ENABLED=1
      - CADDY_GEN_NETWORK=gateway
      - CADDY_GEN_OUTFILE=/etc/caddy/sites/docker-sites.caddy

    networks:
      - caddy

volumes:
  caddy_data:

networks:
  caddy:
    external: true
    name: caddy
```
