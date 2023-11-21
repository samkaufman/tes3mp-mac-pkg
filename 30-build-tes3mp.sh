#!/usr/bin/env zsh
set -e
. ./_common.sh

pushd "$SRC/TES3MP"

# export CMAKE_PREFIX_PATH="$OUT/lib;$CMAKE_PREFIX_PATH"
# export CMAKE_PREFIX_PATH="/usr/local/Cellar/bullet/3.25/lib/bullet/double;$CMAKE_PREFIX_PATH"
# export CMAKE_PREFIX_PATH="$SRC/SDL2/build;$CMAKE_PREFIX_PATH"

mkdir -p build
pushd build
cmake -Wno-dev -DOPENMW_LTO_BUILD=ON \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_OSX_ARCHITECTURES=arm64\;x86_64 \
      -DCMAKE_C_COMPILER="$CC_NO_SCCACHE" \
      -DCMAKE_CXX_COMPILER="$CXX_NO_SCCACHE" \
      -DCMAKE_INSTALL_PREFIX="$OUT/tes3mp" \
      -DBUILD_OPENCS=OFF \
      -DCMAKE_CXX_STANDARD=14 \
      -DCMAKE_CXX_FLAGS="-std=c++14" \
      -DDESIRED_QT_VERSION=5 \
      -DOPENMW_USE_SYSTEM_OSG=ON \
      -DOSGPlugins_DONT_FIND_DEPENDENCIES=ON \
      -DOPENMW_USE_SYSTEM_MYGUI=ON \
      -DMyGUI_INCLUDE_DIR="$MYGUI_HOME/Headers" \
      -DMyGUI_LIBRARY="$MYGUI_HOME/MyGUIEngine" \
      -DRakNet_INCLUDES="$RAKNET_ROOT/include" \
      -DRakNet_LIBRARY_DEBUG="$RAKNET_ROOT/lib/libRakNetLibStatic.a" \
      -DRakNet_LIBRARY_RELEASE="$RAKNET_ROOT/lib/libRakNetLibStatic.a" \
      -DLZ4_INCLUDE_DIR="$LZ4_DIR/include" \
      -DLZ4_LIBRARY_RELEASE="$LZ4_DIR/lib/liblz4.dylib" \
      -DOPENMW_USE_SYSTEM_BULLET=OFF \
      -DOPENMW_OSX_DEPLOYMENT=TRUE \
      -GNinja ..
cmake --build .
mkdir -p "$OUT/tes3mp"

popd
popd