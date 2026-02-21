#!/bin/bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "$0")/.." && pwd)"
ARCHIVE="$BASEDIR/sources/dotnet-sdk-10.0.103-osx-arm64.tar.gz"
ARCHIVE_PARTS="$BASEDIR/sources/dotnet-sdk-10.0.103-osx-arm64.tar.gz.part-"
PREFIX="/usr/local"
DOTNET_DIR="$PREFIX/dotnet"

# Reassemble split archive if the full file does not exist
if [ ! -f "$ARCHIVE" ]; then
    echo "==> Reassembling split archive..."
    cat "${ARCHIVE_PARTS}"* > "$ARCHIVE"
fi

echo "==> Creating $DOTNET_DIR..."
sudo mkdir -p "$DOTNET_DIR"

echo "==> Extracting .NET SDK to $DOTNET_DIR..."
sudo tar xzf "$ARCHIVE" -C "$DOTNET_DIR"

echo "==> Removing quarantine attribute..."
sudo xattr -dr com.apple.quarantine "$DOTNET_DIR"

echo "==> Done. Installed to $DOTNET_DIR"
echo ""
echo "Add the following to your shell profile:"
echo "  export DOTNET_ROOT=$DOTNET_DIR"
echo "  export PATH=\"$DOTNET_DIR:\$PATH\""
