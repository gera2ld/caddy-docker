# caddy

This is an unofficial build for caddy, with additional features:

- DNS challenge for SSL
- Generate Caddyfile automatically from docker labels via [docker-gen](https://github.com/nginx-proxy/docker-gen)

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
      - ./docker-gen:/etc/docker-gen
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - CADDY_DOCKER_GEN=1
      - CADDY_NETWORK=caddy
    networks:
      - caddy

volumes:
  caddy_data:

networks:
  caddy:
    external: true
    name: caddy
```

Then in `/etc/caddy/Caddyfile`:

```caddy
*.mysite.com {
  tls {
    # ...
  }

  import /etc/docker-gen/docker-sites.caddy
}
```

Other services with automatic configuration:

```yaml
services:
  my-service-1:
    # ...
    labels:
      # Multiple reverse proxies
      virtual.bind: 3000 my-service.example.com; 3001 my-api.example.com
  my-service-2:
    # ...
    labels:
      # Extra directives for a reverse proxy
      virtual.bind: 3000 my-service.example.com | header_up Accept-Encoding identity

networks:
  default:
    external: true
    name: caddy
```
