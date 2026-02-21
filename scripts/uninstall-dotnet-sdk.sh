#!/bin/bash
set -euo pipefail

PREFIX="/usr/local"
DOTNET_DIR="$PREFIX/dotnet"

echo "==> Uninstalling .NET SDK from $DOTNET_DIR..."
sudo rm -rf "$DOTNET_DIR"

echo "==> Done. Removed $DOTNET_DIR"
echo ""
echo "Remember to remove these lines from your shell profile:"
echo "  export DOTNET_ROOT=$DOTNET_DIR"
echo "  export PATH=\"$DOTNET_DIR:\$PATH\""
