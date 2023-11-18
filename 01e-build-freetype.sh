#!/usr/bin/env zsh
set -ex
. ./_common.sh

pushd "$SRC/freetype"
mkdir -p build
pushd build
cmake -GNinja \
      -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=TRUE \
      -DCMAKE_INSTALL_PREFIX="$FREETYPE_DIR" \
      -DFT_DISABLE_HARFBUZZ=TRUE \
      -DFT_DISABLE_BROTLI=TRUE \
      -DFT_DISABLE_PNG=TRUE \
      -DFT_DISABLE_BZIP2=TRUE \
      -DCMAKE_OSX_ARCHITECTURES:STRING=x86_64\;arm64 \
      ..
cmake --build .
mkdir -p "$FREETYPE_DIR"
cmake --install . --prefix "$FREETYPE_DIR"
popd
popd