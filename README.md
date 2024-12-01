# caddy

This is an unofficial build for caddy, with additional features:

- DNS challenge for SSL
- Add Cloudflare IP ranges to trusted proxies

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
    networks:
      - caddy

volumes:
  caddy_data:

networks:
  caddy:
    external: true
    name: caddy
```
