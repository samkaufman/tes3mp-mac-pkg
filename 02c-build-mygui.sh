#!/usr/bin/env zsh
set -ex
. ./_common.sh

pushd "$SRC/mygui"

mkdir -p build
pushd build
cmake -Wno-dev \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_OSX_ARCHITECTURES:STRING=x86_64\;arm64 \
      -DCMAKE_C_COMPILER="$CC_NO_SCCACHE" \
      -DCMAKE_CXX_COMPILER="$CXX_NO_SCCACHE" \
      -DCMAKE_CC_COMPILER_LAUNCHER="" \
      -DCMAKE_CXX_COMPILER_LAUNCHER="" \
      -DMYGUI_RENDERSYSTEM=4 \
      -DMYGUI_DISABLE_PLUGINS=TRUE \
      -DMYGUI_BUILD_DEMOS=OFF \
      -DMYGUI_BUILD_PLUGINS=OFF \
      -DMYGUI_BUILD_TOOLS=OFF \
      -DMYGUI_BUILD_DOCS=OFF \
      -DFREETYPE_LIBRARY_RELEASE="$FREETYPE_DIR/lib/libfreetype.dylib" \
      -DFREETYPE_INCLUDE_DIR="$FREETYPE_DIR/include/freetype2" \
      -DSDL2_LIBRARY_RELEASE="$SDL2DIR/lib/libSDL2.dylib" \
      -DSDL2_INCLUDE_DIR="$SDL2DIR/include" \
      -GNinja \
      ..
cmake --build .
cp -r lib/MyGUIEngine.framework "$LIB/"
popd
popd