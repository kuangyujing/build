#!/bin/bash
set -euo pipefail

BUILDROOT="/Users/k/build"
PACKAGE="vim-9.1.0983"
ARCHIVE="${BUILDROOT}/sources/${PACKAGE}.zip"
WORKDIR="${BUILDROOT}/work/${PACKAGE}"

if [ ! -f "$ARCHIVE" ]; then
  echo "Error: archive not found: $ARCHIVE" >&2
  exit 1
fi

echo "==> Extracting ${PACKAGE}"
cd "${BUILDROOT}/work"
rm -rf "$PACKAGE"
unzip -q "$ARCHIVE"

echo "==> Configuring ${PACKAGE}"
cd "${WORKDIR}/src"
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

echo "==> Building ${PACKAGE}"
make -j"$(sysctl -n hw.ncpu)"

echo "==> Testing ${PACKAGE}"
make test

echo "==> Done. To install, run:"
echo "    cd ${WORKDIR}/src && sudo make install"
