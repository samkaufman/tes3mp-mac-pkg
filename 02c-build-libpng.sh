#!/usr/bin/env zsh
set -e
. ./_common.sh

pushd "$SRC/libpng"

readonly COMMON_CMAKE_ARGS=(
    -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_STATIC=NO
    -DCMAKE_C_COMPILER="$CC_NO_SCCACHE" -DCMAKE_CXX_COMPILER="$CXX_NO_SCCACHE")

# Build ARM version.
mkdir -p build-arm
pushd build-arm
cmake $COMMON_CMAKE_ARGS -DCMAKE_OSX_ARCHITECTURES=arm64 ..
cmake --build .
popd

# Build x86_64 version.
mkdir -p build-x86
pushd build-x86
cmake $COMMON_CMAKE_ARGS -DCMAKE_OSX_ARCHITECTURES=x86_64 \
      -DCMAKE_INSTALL_PREFIX="$PNG_ROOT" \
      -DARMV8_BUILD=../build-arm ..
cmake --build .
mkdir -p "$PNG_ROOT"
cmake --install . --prefix "$PNG_ROOT"
popd

# Merge ARM slices into all "installed" libraries.
pushd "$PNG_ROOT/lib"
for f in *.dylib; do
    if ! [[ -L "$f" ]]; then
        mv "$f" "$f.orig"
        lipo -create -output $(basename "$f") "$SRC/libpng/build-arm"/$(basename "$f") "$f.orig"
    fi
done
popd

popd