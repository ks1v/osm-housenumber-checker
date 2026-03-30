#!/usr/bin/env bash
# deploy.sh — copies app files to /opt/osm-housenumber-checker
# Run from the repo root: ~/osm-housenumber-checker/deploy.sh
set -e

DEST=/opt/osm-housenumber-checker
FILES=(index.html settings.js)

echo "==> osm-housenumber-checker deploy"

# Verify we're in the right directory
for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "ERROR: '$f' not found. Run this script from the repo root." >&2
    exit 1
  fi
done

# Create destination if needed
if [[ ! -d "$DEST" ]]; then
  echo "==> Creating $DEST"
  sudo mkdir -p "$DEST"
fi

# Copy files
echo "==> Copying files to $DEST"
sudo cp "${FILES[@]}" "$DEST/"
sudo chmod 644 "$DEST"/*.html "$DEST"/*.js

echo ""
echo "Done. Files in $DEST:"
ls -lh "$DEST"
echo ""
echo "Serve options:"
echo "  python3 -m http.server 8080 --directory $DEST"
echo "  nginx:  set 'root $DEST;' in your server block"
