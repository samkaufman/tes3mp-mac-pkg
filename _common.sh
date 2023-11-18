#!/usr/bin/env zsh
. ./versions.sh

OUT=${OUT:-./out}
OUT=${OUT:P}
SRC="$OUT/src"
LIB="$OUT/lib"

BUILD_SB="./build-config.sb"
BUILD_SB=${BUILD_SB:P}

readonly SED=gsed  # TODO: Document need for gsed.

# Choose Homebrew LLVM
# export CC="/usr/local/opt/llvm/bin/clang"
# export CXX="/usr/local/opt/llvm/bin/clang++"
# export LLD="/usr/local/opt/llvm/bin/ld64.lld"
# export CC_LD="/usr/local/opt/llvm/bin/ld64.lld"
# export PATH="/usr/local/opt/llvm/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/llvm/lib"
# export CFLAGS="-I/usr/local/opt/llvm/include"
# export CPPFLAGS="-I/usr/local/opt/llvm/include"

# export ICONV_DIR="$LIB/iconv"
export GETTEXT_DIR="$LIB/gettext"
export PCRE2_DIR="$LIB/pcre2"
export GLIB_DIR="$LIB/glib"
export FREETYPE_DIR="$LIB/freetype"
export SDL2DIR="$LIB/SDL2"  # TODO: grep and replace
export OSG_DIR="$LIB/osg"  # TODO: grep and replace
export OPENTHREADS_DIR="$LIB/osg"  # TODO: grep and replace
export PNG_ROOT="$LIB/libpng"  # TODO: grep and replace
export JPEG_ROOT="$LIB/libjpeg"  # TODO: grep and replace
export BOOST_ROOT="$LIB/boost"  # TODO: grep and replace
export QT5_PREFIX="$LIB/qt5"
export UNSHIELD_PREFIX="$LIB/unshield"
export RAKNET_ROOT="$LIB/raknet"
export COLLADA_ROOT="$LIB/collada-dom"
export LUAJIT_DIR="$LIB/luajit"
export OPENAL_DIR="$LIB/openal"
export BULLET_DIR="$LIB/bullet"
export FFMPEG_DIR="$LIB/ffmpeg"
export LZ4_DIR="$LIB/lz4"
# export ZLIB_LIBRARY_PATH="$LIB/zlib/lib"  # TODO: grep and replace
# export ZLIB_INCLUDE="$LIB/zlib/include"  # TODO: grep and replace

export MYGUI_HOME="$LIB/MyGUIEngine.framework"  # TODO: grep and replace

export MACOSX_DEPLOYMENT_TARGET=12.0

# Use stock clang everywhere.
# TODO: Remove sccache.
export SCCACHE_CACHE_MULTIARCH=1
export CC_NO_SCCACHE="/usr/bin/clang" CXX_NO_SCCACHE="/usr/bin/clang++"
export CC="$(which sccache) $CC_NO_SCCACHE" CXX="$(which sccache) $CXX_NO_SCCACHE"
# export CC="$CC_NO_SCCACHE" CXX="$CXX_NO_SCCACHE"

# Reset LDFLAGS, LD_LIBRARY_PATH, and PKG_CONFIG_PATH so we don't accidentally use
# non-stock libraries (e.g., from Homebrew).
unset LDFLAGS
unset LD_LIBRARY_PATH
export PKG_CONFIG_PATH="$PNG_ROOT/lib/pkgconfig:\
$JPEG_ROOT/lib/pkgconfig:\
$PCRE2_DIR/lib/pkgconfig:\
$FREETYPE_DIR/lib/pkgconfig:\
$SDL2DIR/lib/pkgconfig:\
$OSG_DIR/lib/pkgconfig:\
$QT5_PREFIX/lib/pkgconfig:\
$UNSHIELD_PREFIX/lib/pkgconfig:\
$COLLADA_ROOT/lib/pkgconfig:\
$LUAJIT_DIR/lib/pkgconfig:\
$OPENAL_DIR/lib/pkgconfig:\
$BULLET_DIR/lib/pkgconfig:\
$FFMPEG_DIR/lib/pkgconfig:\
$LZ4_DIR/lib/pkgconfig"

export CPATH="$PCRE2_DIR/include:$FREETYPE_DIR/include:$SDL2DIR/include"
export CMAKE_PREFIX_PATH="$BULLET_DIR:$FREETYPE_DIR:$SDL2DIR:$QT5_PREFIX"

# Prevent pkg-config from looking its default directories.
export PKG_CONFIG_LIBDIR=

universalize_install_dirs() {
    mkdir -p "$1"
    local dest="$1"
    shift

    # cd into the first non-destination folder
    pushd "$1"

    while IFS= read -r -d '' file; do
        local new_paths=()
        for folder_path in "$@"; do
            new_paths+=("$folder_path/$file")
        done
        mkdir -p $(dirname "$dest/$file")
        lipo -create -output "$dest/$file" $new_paths
    done < <(find . -type f \( -iname "*.dylib" -o -iname "*.a" \) -print0)

    popd
}

box() {
    local root="$1"
    shift
    sandbox-exec -f "$BUILD_SB" -D TMPDIR="$TMPDIR" -D HOME="$HOME" -D SRC="$PWD" -D BUILD="$PWD" -D INSTALLROOT="$root" $*
}