#!/bin/bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "$0")/.." && pwd)"
ARCHIVE="$BASEDIR/sources/ripgrep-15.1.0-aarch64-apple-darwin.tar.gz"
WORKDIR="$BASEDIR/work/ripgrep-15.1.0-aarch64-apple-darwin"
PREFIX="/usr/local"

echo "==> Extracting ripgrep..."
cd "$BASEDIR/work"
rm -rf ripgrep-15.1.0-aarch64-apple-darwin
tar xf "$ARCHIVE"

echo "==> Removing quarantine attribute..."
xattr -dr com.apple.quarantine "$WORKDIR"

echo "==> Installing rg to $PREFIX/bin/..."
sudo cp "$WORKDIR/rg" "$PREFIX/bin/rg"
sudo chmod 755 "$PREFIX/bin/rg"

echo "==> Installing man page to $PREFIX/share/man/man1/..."
sudo mkdir -p "$PREFIX/share/man/man1"
sudo cp "$WORKDIR/doc/rg.1" "$PREFIX/share/man/man1/rg.1"

echo "==> Installing shell completions..."
sudo mkdir -p "$PREFIX/share/bash-completion/completions"
sudo cp "$WORKDIR/complete/rg.bash" "$PREFIX/share/bash-completion/completions/rg"
sudo mkdir -p "$PREFIX/share/fish/vendor_completions.d"
sudo cp "$WORKDIR/complete/rg.fish" "$PREFIX/share/fish/vendor_completions.d/rg.fish"
sudo mkdir -p "$PREFIX/share/zsh/site-functions"
sudo cp "$WORKDIR/complete/_rg" "$PREFIX/share/zsh/site-functions/_rg"

echo "==> Done. Installed:"
echo "    $PREFIX/bin/rg"
echo "    $PREFIX/share/man/man1/rg.1"
echo "    $PREFIX/share/bash-completion/completions/rg"
echo "    $PREFIX/share/fish/vendor_completions.d/rg.fish"
echo "    $PREFIX/share/zsh/site-functions/_rg"
