#!/bin/bash
set -euo pipefail

BUILDROOT="/Users/k/build"
PACKAGE="coreutils-9.5"
ARCHIVE="${BUILDROOT}/sources/${PACKAGE}.tar.gz"
WORKDIR="${BUILDROOT}/work/${PACKAGE}"

if [ ! -f "$ARCHIVE" ]; then
  echo "Error: archive not found: $ARCHIVE" >&2
  exit 1
fi

echo "==> Extracting ${PACKAGE}"
cd "${BUILDROOT}/work"
rm -rf "$PACKAGE"
tar xf "$ARCHIVE"

echo "==> Configuring ${PACKAGE}"
cd "$WORKDIR"
./configure

echo "==> Building ${PACKAGE}"
make -j"$(sysctl -n hw.ncpu)"

echo "==> Testing ${PACKAGE}"
make check

echo "==> Done. To install, run:"
echo "    cd ${WORKDIR} && sudo make install"
