#!/usr/bin/env bash
# deploy.sh — deploy to Ubuntu server
# Run from the repo root after pulling: ~/osm-housenumber-checker/deploy.sh
set -e

APP=osm-housenumber-checker
DEST=/opt/$APP
FILES=(index.html settings.js)
NGINX_CONF=/etc/nginx/sites-available/$APP

echo "==> $APP deploy"

# Verify source files exist
for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "ERROR: '$f' not found. Run from the repo root." >&2
    exit 1
  fi
done

# Install nginx if missing
if ! command -v nginx &>/dev/null; then
  echo "==> Installing nginx..."
  sudo apt-get update -q
  sudo apt-get install -y nginx
fi

# Create destination
sudo mkdir -p "$DEST"

# Copy app files
echo "==> Copying files to $DEST"
sudo cp "${FILES[@]}" "$DEST/"
sudo chmod 644 "$DEST"/*.html "$DEST"/*.js

# Create nginx site config if it doesn't exist yet
if [[ ! -f "$NGINX_CONF" ]]; then
  echo "==> Creating nginx site config at $NGINX_CONF"
  sudo tee "$NGINX_CONF" > /dev/null <<EOF
server {
    listen 80;
    server_name _;

    root $DEST;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
  # Enable site
  sudo ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/$APP
  # Disable default site if still enabled
  if [[ -f /etc/nginx/sites-enabled/default ]]; then
    sudo rm /etc/nginx/sites-enabled/default
  fi
fi

# Validate config and reload
sudo nginx -t
sudo systemctl reload nginx

echo ""
echo "==> Done. Files in $DEST:"
ls -lh "$DEST"
echo ""
SERVER_IP=$(hostname -I | awk '{print $1}')
echo "Available at: http://$SERVER_IP/"
