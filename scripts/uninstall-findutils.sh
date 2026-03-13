#!/bin/bash
set -euo pipefail

BUILDROOT="/Users/k/build"
PACKAGE="findutils-4.10.0"
ARCHIVE="${BUILDROOT}/sources/${PACKAGE}.tar.xz"
WORKDIR="${BUILDROOT}/work/${PACKAGE}"

if [ ! -f "${WORKDIR}/Makefile" ]; then
  echo "==> Work directory not ready, extracting and configuring ${PACKAGE}"
  if [ ! -f "$ARCHIVE" ]; then
    echo "Error: archive not found: $ARCHIVE" >&2
    exit 1
  fi
  cd "${BUILDROOT}/work"
  rm -rf "$PACKAGE"
  tar xf "$ARCHIVE"
  cd "$WORKDIR"
  ./configure
else
  cd "$WORKDIR"
fi

echo "==> Uninstalling ${PACKAGE}"
sudo make uninstall
echo "==> Done."
