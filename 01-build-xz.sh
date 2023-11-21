#!/usr/bin/env zsh
set -e
. ./_common.sh

run_in_sandbox() {
  sandbox-exec -f "$BUILD_SB" -D TMPDIR="$TMPDIR" -D HOME="$HOME" \
    -D SRC="$PWD" -D BUILD="$PWD" -D INSTALLROOTROOT="$LIB" \
    -D INSTALLROOT="$XZ_DIR" "$@"
}

pushd "$SRC/xz"

CFLAGS="-arch x86_64 -arch arm64" \
CXXFLAGS="-arch x86_64 -arch arm64" \
    run_in_sandbox ./configure --disable-debug --disable-dependency-tracking \
        --prefix="$XZ_DIR"
run_in_sandbox make clean
run_in_sandbox make -j$(sysctl -n hw.logicalcpu)
run_in_sandbox make -j1 install

popd
