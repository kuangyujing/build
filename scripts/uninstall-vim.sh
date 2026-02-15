#!/bin/bash
set -euo pipefail

BUILDROOT="/Users/k/build"
PACKAGE="vim-9.1.0983"
ARCHIVE="${BUILDROOT}/sources/${PACKAGE}.zip"
WORKDIR="${BUILDROOT}/work/${PACKAGE}"
SRCDIR="${WORKDIR}/src"

if [ ! -f "${SRCDIR}/auto/config.mk" ]; then
  echo "==> Work directory not ready, extracting and configuring ${PACKAGE}"
  if [ ! -f "$ARCHIVE" ]; then
    echo "Error: archive not found: $ARCHIVE" >&2
    exit 1
  fi
  cd "${BUILDROOT}/work"
  rm -rf "$PACKAGE"
  unzip -q "$ARCHIVE"
  cd "$SRCDIR"
  ./configure \
    --with-features=huge \
    --disable-luainterp \
    --disable-mzschemeinterp \
    --disable-perlinterp \
    --disable-pythoninterp \
    --disable-python3interp \
    --disable-tclinterp \
    --disable-rubyinterp \
    --disable-netbeans \
    --enable-multibyte \
    --enable-largefile \
    --enable-fail-if-missing \
    '--with-compiledby=Kuangyu Jing'
else
  cd "$SRCDIR"
fi

echo "==> Uninstalling ${PACKAGE}"
sudo make uninstall
echo "==> Done."
