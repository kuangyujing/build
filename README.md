# macOS Toolchain Build

Build UNIX tools from source for macOS (arm64) without Homebrew.

## Packages

| Package | Version | Type |
|---|---|---|
| Bash | 5.2.37 | source |
| GNU Coreutils | 9.5 | source |
| ripgrep | 15.1.0 | prebuilt binary |
| Vim | 9.1.0983 | source |

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

# install a prebuilt binary package
./scripts/install-ripgrep.sh
```

Binaries install to `/usr/local/bin/` by default.

## Claude Code Commands

```
/build <package>       # build a package (extract, configure, compile, test)
/uninstall <package>   # uninstall a package from /usr/local
```
