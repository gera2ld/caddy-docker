GOOS=${GOOS:-linux}
GOARCH=${GOARCH:-amd64}

XCADDY_VERSION=0.4.4
XCADDY_URL=https://github.com/caddyserver/xcaddy/releases/download/v${XCADDY_VERSION}/xcaddy_${XCADDY_VERSION}_linux_amd64.tar.gz
XCADDY_TGZ=xcaddy.tar.gz
XCADDY=$PWD/temp/xcaddy

# Install xcaddy
mkdir -p temp
pushd temp
if [ -f $XCADDY ]; then
  echo xcaddy is already downloaded
else
  echo Downloading: $XCADDY_URL
  curl -fsSLo $XCADDY_TGZ $XCADDY_URL
  tar xvf $XCADDY_TGZ
fi
popd

echo Building: $CADDY_VERSION
env \
  XCADDY_GO_BUILD_FLAGS="-ldflags '-s -w' -trimpath" \
  $XCADDY build $CADDY_VERSION \
  --output bin/caddy-$GOOS-$GOARCH \
  --with github.com/caddy-dns/cloudflare \
  --with github.com/greenpau/caddy-security \
  --with github.com/WeidiDeng/caddy-cloudflare-ip \
  --with github.com/fvbommel/caddy-dns-ip-range \
  --with github.com/fvbommel/caddy-combine-ip-ranges \
  --with github.com/mholt/caddy-l4
# --with github.com/caddy-dns/alidns \
