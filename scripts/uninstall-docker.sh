#!/bin/bash
set -euo pipefail

PREFIX="/usr/local"
SBIN_DIR="$PREFIX/sbin"

echo "==> Removing $SBIN_DIR/docker..."
sudo rm -f "$SBIN_DIR/docker"

echo "==> Done. Removed docker."
