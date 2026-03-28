#!/bin/bash
set -euo pipefail

PREFIX="/usr/local"
NODE_DIR="$PREFIX/node"

echo "==> Removing symlinks from $PREFIX/bin/..."
for bin in node npm npx corepack; do
    sudo rm -f "$PREFIX/bin/$bin"
done

echo "==> Removing man page symlink..."
sudo rm -f "$PREFIX/share/man/man1/node.1"

echo "==> Removing $NODE_DIR..."
sudo rm -rf "$NODE_DIR"

echo "==> Done. Removed all Node.js files."
