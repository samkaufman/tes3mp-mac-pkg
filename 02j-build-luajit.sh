#!/usr/bin/env zsh
set -e
. ./_common.sh

run_in_sandbox() {
  sandbox-exec -f "$BUILD_SB" -D TMPDIR="$TMPDIR" -D HOME="$HOME" \
    -D SRC="$PWD" -D BUILD="$PWD" -D INSTALLROOTROOT="$LIB" \
    -D INSTALLROOT="$LUAJIT_DIR" "$@"
}

pushd "$SRC/luajit"
run_in_sandbox make -j$(sysctl -n hw.logicalcpu) \
  DEFAULT_CC="$CC" TARGET_FLAGS="-arch x86_64"
run_in_sandbox make install PREFIX="$LUAJIT_DIR/x86"
run_in_sandbox make clean
run_in_sandbox make -j$(sysctl -n hw.logicalcpu) \
  DEFAULT_CC="$CC" TARGET_FLAGS="-arch arm64"
run_in_sandbox make install PREFIX="$LUAJIT_DIR"
popd


universalize_install_dirs "$LUAJIT_DIR" "$LUAJIT_DIR/x86" "$LUAJIT_DIR"
rm -r "$LUAJIT_DIR/x86" "$LUAJIT_DIR/bin"