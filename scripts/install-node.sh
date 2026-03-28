#!/bin/bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "$0")/.." && pwd)"
ARCHIVE="$BASEDIR/sources/node-v24.14.1-darwin-arm64.tar.gz"
PREFIX="/usr/local"
NODE_DIR="$PREFIX/node"

echo "==> Creating $NODE_DIR..."
sudo mkdir -p "$NODE_DIR"

echo "==> Extracting Node.js to $NODE_DIR..."
sudo tar xzf "$ARCHIVE" --strip-components=1 -C "$NODE_DIR"

echo "==> Removing quarantine attribute..."
sudo xattr -dr com.apple.quarantine "$NODE_DIR"

echo "==> Creating symlinks in $PREFIX/bin/..."
for bin in node npm npx corepack; do
    sudo ln -sf "$NODE_DIR/bin/$bin" "$PREFIX/bin/$bin"
    echo "    $PREFIX/bin/$bin -> $NODE_DIR/bin/$bin"
done

echo "==> Installing man page..."
sudo mkdir -p "$PREFIX/share/man/man1"
sudo ln -sf "$NODE_DIR/share/man/man1/node.1" "$PREFIX/share/man/man1/node.1"

echo "==> Done. Installed to $NODE_DIR"
