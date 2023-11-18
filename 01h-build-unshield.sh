#!/usr/bin/env zsh
set -e
. ./_common.sh

pushd "$SRC/unshield"

# Build universal binary.
mkdir -p build
pushd build
cmake -DCMAKE_BUILD_TYPE=Release \
      -DENABLE_STATIC=NO \
      -DCMAKE_INSTALL_PREFIX="$UNSHIELD_ROOT" \
      -DCMAKE_OSX_ARCHITECTURES:STRING=x86_64\;arm64 \
      -DUSE_OUR_OWN_MD5=ON \
      -GNinja ..
cmake --build .
cmake --install . --prefix "$UNSHIELD_ROOT"
popd

popd