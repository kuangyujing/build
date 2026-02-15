# macOS Toolchain Build

Build UNIX tools from source for macOS (arm64) without Homebrew.

## Packages

| Package | Version | Status |
|---|---|---|
| Bash | 5.2.37 | built |
| GNU Coreutils | 9.5 | built |
| Vim | 9.1.0983 | not yet built |

## Layout

- `sources/` — downloaded archives (tarballs, zips)
- `work/` — extracted sources and build artifacts
- `scripts/` — per-package build scripts

## Usage

```bash
# build a package (extract, configure, compile, test)
./scripts/build-vim.sh

# install after a successful build
cd work/vim-9.1.0983/src && sudo make install
```

Binaries install to `/usr/local/bin/` by default.
