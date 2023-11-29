#!/usr/bin/env zsh
set -e
. ./_common.sh

run_in_sandbox() {
  sandbox-exec -f "$BUILD_SB" -D TMPDIR="$TMPDIR" -D HOME="$HOME" \
    -D SRC="$PWD" -D BUILD="$PWD" -D INSTALLROOTROOT="$LIB" \
    -D INSTALLROOT="$UNSHIELD_ROOT" "$@"
}

pushd "$SRC/pcre2"

pushd "$SRC/unshield"

# Build universal binary.
mkdir -p build
pushd build
cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_C_COMPILER="$CC_NO_SCCACHE" \
      -DCMAKE_CXX_COMPILER="$CXX_NO_SCCACHE" \
      -DENABLE_STATIC=NO \
      -DCMAKE_INSTALL_PREFIX="$UNSHIELD_ROOT" \
      -DCMAKE_OSX_ARCHITECTURES:STRING=x86_64\;arm64 \
      -DUSE_OUR_OWN_MD5=ON \
      -GNinja ..
cmake --build .
cmake --install . --prefix "$UNSHIELD_ROOT"
popd

popd