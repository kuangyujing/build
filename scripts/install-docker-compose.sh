#!/bin/bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "$0")/.." && pwd)"
BINARY="$BASEDIR/sources/docker-compose-darwin-aarch64"
PLUGIN_DIR="$HOME/.docker/cli-plugins"

echo "==> Creating $PLUGIN_DIR..."
mkdir -p "$PLUGIN_DIR"

echo "==> Installing docker-compose plugin to $PLUGIN_DIR/docker-compose..."
install -m 755 "$BINARY" "$PLUGIN_DIR/docker-compose"

echo "==> Removing quarantine attribute..."
xattr -d com.apple.quarantine "$PLUGIN_DIR/docker-compose" 2>/dev/null || true

echo "==> Done. Installed to $PLUGIN_DIR/docker-compose"
"$PLUGIN_DIR/docker-compose" version
