# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Build UNIX tools from source for macOS (arm64) without Homebrew. The goal is building and deploying the toolchain, not modifying upstream source code.

## Environment

- Compiler: Apple clang (invoked as `gcc`)
- Target: arm64-apple-darwin
- Install prefix: `/usr/local` (default)

## Directory Structure

```
/Users/k/build/
├── CLAUDE.md
├── sources/          # Downloaded archives (tarballs, zips)
│   ├── bash-5.2.37.tar.gz
│   ├── coreutils-9.5.tar.gz
│   ├── vim-9.1.0983.zip
│   └── vim-9.1.tar.bz2
└── work/             # Extracted sources and build artifacts
    ├── bash-5.2.37/
    ├── coreutils-9.5/
    └── vim-9.1.0983/
```

- `sources/`: Original archives. Keep these intact so builds can be redone from scratch.
- `work/`: Extract and build here. Safe to `make distclean` or delete and re-extract.

## Packages

| Package | Version | Source archive | Work directory |
|---|---|---|---|
| Bash | 5.2.37 | `sources/bash-5.2.37.tar.gz` | `work/bash-5.2.37/` |
| GNU Coreutils | 9.5 | `sources/coreutils-9.5.tar.gz` | `work/coreutils-9.5/` |
| Vim | 9.1.0983 | `sources/vim-9.1.0983.zip` | `work/vim-9.1.0983/` |

## How to Find the Configure Options Used for a Build

The exact configure invocation is recorded in two places within each built package:
- `config.log` header: look for the `Invocation command line was` line
- `config.status`: the `ac_cs_config` variable

## Build Instructions

All packages use GNU Autotools (`./configure && make`).

### Bash

```bash
cd /Users/k/build/work
tar xf ../sources/bash-5.2.37.tar.gz
cd bash-5.2.37
./configure              # no options (verified from config.log)
make
make test
sudo make install        # installs to /usr/local/bin/bash
```

### GNU Coreutils

```bash
cd /Users/k/build/work
tar xf ../sources/coreutils-9.5.tar.gz
cd coreutils-9.5
./configure              # no options (verified from config.log)
make
make check                                       # full test suite
make check TESTS=tests/ls/ls-time.sh VERBOSE=yes # single test
sudo make install        # installs to /usr/local/bin/
```

### Vim

```bash
cd /Users/k/build/work
unzip ../sources/vim-9.1.0983.zip
cd vim-9.1.0983/src
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
make
make test
sudo make install        # installs to /usr/local/bin/vim
```

Vim configure options explained:
- `--with-features=huge`: enable the maximum feature set
- `--disable-*interp`: disable all script language bindings (Lua, Perl, Python, Tcl, Ruby) to eliminate external dependencies
- `--enable-multibyte`: multibyte character support (CJK, etc.)
- `--enable-fail-if-missing`: abort configure immediately if a requested feature's dependency is not found
- `--with-compiledby`: embed builder identity

## Deployment

```bash
sudo make install        # run in each package's work directory
```

Installs to `/usr/local/bin/`, `/usr/local/share/man/`, etc. by default.
To use a different prefix: `./configure --prefix=/opt/local`.

To prioritize the built tools over macOS system commands (`/usr/bin/`):

```bash
export PATH="/usr/local/bin:$PATH"
```

## Claude Code Commands

Build a package (extract, configure, compile, test):

```
/build <package>     e.g. /build vim
```

Uninstall a package from `/usr/local`. This works even if the work directory has been cleaned — the script will re-extract and configure as needed:

```
/uninstall <package>   e.g. /uninstall vim
```

## Clean Rebuild

```bash
make clean       # remove object files
make distclean   # remove all generated files including configure output (must re-run ./configure)
```

## Troubleshooting

### configure failure

- Check `config.log` for details on failed feature checks.
- Xcode Command Line Tools are required: `xcode-select --install`
- If headers are missing, verify the macOS SDK path: `xcrun --show-sdk-path`
- To explicitly pass the SDK path:
  ```bash
  CFLAGS="-isysroot $(xcrun --show-sdk-path)" ./configure
  ```

### make failure

- Check the end of `config.log` for the last successful/failed checks.
- Missing header errors usually indicate a missing or outdated Xcode CLT.
- For linker errors (`ld: symbol(s) not found`), specify library paths:
  ```bash
  LDFLAGS="-L/usr/local/lib" ./configure
  ```

### Coreutils test failures on macOS

- Some tests require root privileges or Linux-specific features (SELinux, etc.) and will be skipped or fail on macOS. This is expected.
- Re-run a single test with `VERBOSE=yes` to diagnose.

## Adding a New Package

1. Download the source archive to `sources/`
2. Extract into `work/`: `tar xf ../sources/<archive>` or `unzip ../sources/<archive>`
3. Run `./configure` and check `config.log` for issues
4. `make`
5. `make check` or `make test`
6. `sudo make install`
7. Create both `scripts/build-<name>.sh` and `scripts/uninstall-<name>.sh`
