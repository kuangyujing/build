#!/bin/bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "$0")/.." && pwd)"
ARCHIVE="$BASEDIR/sources/docker-29.1.3.tgz"
PREFIX="/usr/local"
SBIN_DIR="$PREFIX/sbin"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "==> Extracting $ARCHIVE to temporary directory..."
tar xzf "$ARCHIVE" -C "$TMPDIR"

echo "==> Creating $SBIN_DIR..."
sudo mkdir -p "$SBIN_DIR"

echo "==> Installing docker to $SBIN_DIR/docker..."
sudo install -m 755 "$TMPDIR/docker/docker" "$SBIN_DIR/docker"

echo "==> Removing quarantine attribute..."
sudo xattr -d com.apple.quarantine "$SBIN_DIR/docker" 2>/dev/null || true

echo "==> Done. Installed to $SBIN_DIR/docker"
"$SBIN_DIR/docker" --version
