#!/usr/bin/env zsh
set -e
. ./_common.sh

pushd "$SRC/osg"
mkdir -p build
pushd build
cmake -Wno-dev \
      -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_C_COMPILER="$CC_NO_SCCACHE" \
      -DCMAKE_CXX_COMPILER="$CXX_NO_SCCACHE" \
      -DCMAKE_INSTALL_PREFIX="$OSG_DIR" \
      -DBUILD_OSG_APPLICATIONS=OFF \
      -DBUILD_OSG_PLUGINS_BY_DEFAULT=0 -DBUILD_OSG_PLUGIN_OSG=1 \
      -DBUILD_OSG_PLUGIN_DAE=1 -DBUILD_OSG_PLUGIN_DDS=1 \
      -DBUILD_OSG_PLUGIN_TGA=1 -DBUILD_OSG_PLUGIN_BMP=1 \
      -DBUILD_OSG_PLUGIN_JPEG=1 -DBUILD_OSG_PLUGIN_PNG=1 \
      -DBUILD_OSG_PLUGIN_IMAGEIO=1 \
      -DBUILD_OSG_PLUGIN_FREETYPE=1 -DBUILD_OSG_DEPRECATED_SERIALIZERS=0 \
      -DOSG_TEXT_USE_FONTCONFIG=NO \
      -DCMAKE_OSX_ARCHITECTURES=arm64\;x86_64 \
      -DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio \
      -DOSG_WINDOWING_SYSTEM=Cocoa \
      -DJPEG_LIBRARY_RELEASE="$JPEG_ROOT/lib/libjpeg.dylib" \
      -DJPEG_INCLUDE_DIR="$JPEG_ROOT/include" \
      -DFREETYPE_INCLUDE_DIRS=$OUT/src/freetype/build/include \
      -DFREETYPE_LIBRARY=$OUT/src/freetype/build/libfreetype.dylib \
      -DPNG_FOUND=TRUE \
      -DPNG_INCLUDE_DIR="$PNG_ROOT/include" \
      -DPNG_LIBRARY="$PNG_ROOT/lib/libpng.dylib" \
      -GNinja ..
cmake --build .
mkdir -p "$OSG_DIR"
cmake --install . --prefix "$OSG_DIR"
popd
popd