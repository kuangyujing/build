#!/bin/bash
set -euo pipefail

BUILDROOT="/Users/k/build"
PACKAGE="findutils-4.10.0"
ARCHIVE="${BUILDROOT}/sources/${PACKAGE}.tar.xz"
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
make -j8

echo "==> Testing ${PACKAGE}"
make check || echo "==> Warning: some tests failed (may be expected on macOS)" >&2

echo "==> Done. To install, run:"
echo "    cd ${WORKDIR} && sudo make install"
