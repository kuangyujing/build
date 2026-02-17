#!/bin/bash
set -euo pipefail

PREFIX="/usr/local"

echo "==> Uninstalling ripgrep from $PREFIX..."
sudo rm -f "$PREFIX/bin/rg"
sudo rm -f "$PREFIX/share/man/man1/rg.1"
sudo rm -f "$PREFIX/share/bash-completion/completions/rg"
sudo rm -f "$PREFIX/share/fish/vendor_completions.d/rg.fish"
sudo rm -f "$PREFIX/share/zsh/site-functions/_rg"

echo "==> Done. Removed all ripgrep files."
