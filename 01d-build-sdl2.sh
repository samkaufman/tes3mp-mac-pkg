#!/usr/bin/env zsh
set -ex
. ./_common.sh

pushd "$SRC/SDL2"

readonly COMMON_CMAKE_ARGS=(
    -DCMAKE_C_COMPILER="$CC_NO_SCCACHE" -DCMAKE_CXX_COMPILER="$CXX_NO_SCCACHE"
    -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_STATIC=NO)

# Build ARM version.
mkdir -p build-arm
pushd build-arm
cmake $COMMON_CMAKE_ARGS -DCMAKE_OSX_ARCHITECTURES:STRING=arm64 ..
cmake --build .
popd

# Build x86_64 version.
mkdir -p build-x86
pushd build-x86
cmake $COMMON_CMAKE_ARGS -DCMAKE_OSX_ARCHITECTURES:STRING=x86_64 \
      -DARMV8_BUILD=../build-arm \
      -DCMAKE_INSTALL_PREFIX="$SDL2DIR" \
      ..
cmake --build .
mkdir -p "$SDL2DIR"
cmake --install . --prefix "$SDL2DIR"
popd

# Merge ARM slices into all "installed" libraries.
pushd "$SDL2DIR/lib"
for f in *.dylib; do
    if ! [[ -L "$f" ]]; then
        mv "$f" "$f.orig"
        lipo -create -output $(basename "$f") "$SRC/SDL2/build-arm"/$(basename "$f") "$f.orig"
    fi
done
popd

popd