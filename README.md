# macOS Toolchain Build

Build UNIX tools from source for macOS (arm64) without Homebrew.

## Packages

| Package | Version | Type |
|---|---|---|
| Bash | 5.2.37 | source |
| .NET SDK | 10.0.103 | prebuilt binary |
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

## Splitting Large Archives

GitHub has a 100 MB file size limit. Archives exceeding this limit are split into smaller parts using `split`.

```bash
# Split a file into 50 MB chunks
split -b 50m <file> <file>.part-

# Reassemble
cat <file>.part-* > <file>
```

Currently split: `sources/dotnet-sdk-10.0.103-osx-arm64.tar.gz` (221 MB, 5 parts).
The install script handles reassembly automatically.

## Claude Code Commands

```
/build <package>       # build a package (extract, configure, compile, test)
/uninstall <package>   # uninstall a package from /usr/local
```
