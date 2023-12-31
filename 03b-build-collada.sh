#!/usr/bin/env zsh
set -e
. ./_common.sh

echo "pkg-config search path is $PKG_CONFIG_PATH"

pushd "$SRC/collada-dom"
mkdir -p build
pushd build
cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_OSX_ARCHITECTURES=arm64\;x86_64 \
      -DCMAKE_INSTALL_PREFIX="$COLLADA_ROOT" \
      -DCMAKE_C_COMPILER="$CC_NO_SCCACHE" \
      -DCMAKE_CXX_COMPILER="$CXX_NO_SCCACHE" \
      -GNinja ..
cmake --build .
mkdir -p "$COLLADA_ROOT"
cmake --install . --prefix "$COLLADA_ROOT"
popd
popd