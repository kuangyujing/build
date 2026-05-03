#!/bin/bash
set -euo pipefail

PLUGIN_DIR="$HOME/.docker/cli-plugins"

echo "==> Removing $PLUGIN_DIR/docker-compose..."
rm -f "$PLUGIN_DIR/docker-compose"

echo "==> Done. Removed docker-compose plugin."
