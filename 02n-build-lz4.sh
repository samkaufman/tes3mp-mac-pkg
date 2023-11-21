#!/usr/bin/env zsh
set -e
. ./_common.sh

run_in_sandbox() {
  sandbox-exec -f "$BUILD_SB" -D TMPDIR="$TMPDIR" -D HOME="$HOME" \
    -D SRC="$PWD" -D BUILD="$PWD" -D INSTALLROOTROOT="$LIB" \
    -D INSTALLROOT="$LZ4_DIR" "$@"
}

pushd "$SRC/lz4"
CFLAGS="-arch x86_64 -arch arm64" \
CXXFLAGS="-arch x86_64 -arch arm64" \
    run_in_sandbox make install PREFIX="$LZ4_DIR"
popd
