#!/usr/bin/env zsh
set -ex
. ./_common.sh

pushd "$SRC/bullet"
mkdir -p build
pushd build
cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="$BULLET_DIR" \
      -DCMAKE_OSX_ARCHITECTURES:STRING=x86_64\;arm64 \
      -DBT_USE_EGL=ON \
      -DBUILD_UNIT_TESTS=OFF \
      -DBUILD_SHARED_LIBS=ON \
      -DBUILD_PYBULLET=OFF \
      -DINSTALL_EXTRA_LIBS=OFF \
      -DBULLET2_MULTITHREADING=ON \
      -DUSE_DOUBLE_PRECISION=ON \
      -GNinja ..
cmake --build .
mkdir -p "$BULLET_DIR"
cmake --install . --prefix "$BULLET_DIR"
popd
popd