#!/usr/bin/env zsh
set -ex
. ./_common.sh

pushd "$SRC/libjpeg-turbo"

readonly COMMON_CMAKE_ARGS="-DCMAKE_BUILD_TYPE=Release -DENABLE_STATIC=NO -GNinja"

# Build ARM version.
mkdir -p build-arm
pushd build-arm
cmake $COMMON_CMAKE_ARGS -DCMAKE_OSX_ARCHITECTURES:STRING=arm64 ..
cmake --build .
popd

# Build x86_64 version, and install to a subdir. in lib.
mkdir -p build-x86
pushd build-x86
cmake $COMMON_CMAKE_ARGS -DCMAKE_OSX_ARCHITECTURES:STRING=x86_64 \
      -DCMAKE_INSTALL_PREFIX="$JPEG_ROOT" \
      -DARMV8_BUILD=../build-arm ..
cmake --build .
mkdir -p "$JPEG_ROOT"
cmake --install . --prefix "$JPEG_ROOT"
popd

# Merge ARM slices into all "installed" libraries.
pushd "$JPEG_ROOT/lib"
for f in *.dylib; do
    if ! [[ -L "$f" ]]; then
        mv "$f" "$f.orig"
        lipo -create -output $(basename "$f") "$SRC/libjpeg-turbo/build-arm"/$(basename "$f") "$f.orig"
    fi
done
popd

popd