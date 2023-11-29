#!/usr/bin/env zsh
set -ex
. ./_common.sh

build_raknet_arch() {
      pushd "$SRC/raknet"
      mkdir -p build-$1
      pushd build-$1
      # -fno-strict-float-cast-overflow needed to emulate the default behavior
      # of older Clang and GCC.
      cmake -DCMAKE_BUILD_TYPE=Release -DCRABNET_ENABLE_DLL=OFF \
            -DCMAKE_C_COMPILER="$CC_NO_SCCACHE" \
            -DCMAKE_CXX_COMPILER="$CXX_NO_SCCACHE" \
            -DCRABNET_ENABLE_SAMPLES=OFF -DCRABNET_ENABLE_STATIC=ON \
            -DCRABNET_GENERATE_INCLUDE_ONLY_DIR=ON \
            -DCMAKE_CXX_STANDARD=11 \
            -DCMAKE_OSX_ARCHITECTURES="$1" \
            -DCMAKE_CXX_FLAGS="-fno-strict-float-cast-overflow" \
            -GNinja ..
      # cmake --build .
      ninja -v
      cmake --install . --prefix "$RAKNET_ROOT/$1"
      popd
      popd
}
build_raknet_arch arm64
build_raknet_arch x86_64

# Merge into a universal RakNet.
universalize_install_dirs "$RAKNET_ROOT" "$RAKNET_ROOT/arm64" "$RAKNET_ROOT/x86_64"
mv "$RAKNET_ROOT/arm64/include" "$RAKNET_ROOT/"
rm -r "$RAKNET_ROOT/arm64" "$RAKNET_ROOT/x86_64"