#!/usr/bin/env zsh
set -ex
. ./_common.sh

readonly LZ4_TAG="v1.9.4"
readonly LUAJIT_TAG="v2.1"
readonly UNSHIELD_TAG="1.5.1"
readonly MYGUI_TAG="59c1388b942721887d18743ada15f1906ff11a1f"
readonly RAKNET_HASH="19e66190e83f53bcdcbcd6513238ed2e54878a21"
readonly OSG_TAG="e65f47c4ab3a0b53cc19f517961671e5f840a08d"

# A general Git repo. cloning function
function clone {
    rm -rf "$2"
    echo "Cloning $1"
    git clone --quiet "$1" "$2"
    if [ -n "$3" ]; then
        pushd "$2"
        git checkout --quiet "$3"
        popd
    fi
}

# A function to download and extract a source tarball.
function download_tar {
    filename=$(basename "$1")

    rm -rf "$2"
    if [ ! -f "$OUT/$filename" ]; then
        echo "Downloading $1"
        curl $1 -L -o "$OUT/$filename"
    fi
    echo "$3" "$OUT/$filename" | sha256sum --check --status || exit 1
    mkdir -p "$2"
    echo "Extracting $2"
    tar --strip-components 1 -C "$2" -xf "$OUT/$filename"
}

mkdir -p "$SRC"

download_tar "https://ftp.gnu.org/gnu/libiconv/libiconv-1.17.tar.gz" \
    "$SRC/iconv" \
    "8f74213b56238c85a50a5329f77e06198771e70dd9a739779f4c02f65d971313"
# TODO: Check the sha256
curl -o "$SRC/iconv-patch-utf8mac.diff" https://raw.githubusercontent.com/Homebrew/patches/9be2793af/libiconv/patch-utf8mac.diff
pushd "$SRC/iconv"
patch -p1 < "$SRC/iconv-patch-utf8mac.diff"
popd

download_tar "https://downloads.sourceforge.net/project/lzmautils/xz-5.4.3.tar.gz" \
    "$SRC/xz" \
    "1c382e0bc2e4e0af58398a903dd62fff7e510171d2de47a1ebe06d1528e9b7e9"
download_tar "https://ftp.gnu.org/gnu/gettext/gettext-0.21.1.tar.gz" \
    "$SRC/gettext" \
    "e8c3650e1d8cee875c4f355642382c1df83058bd5a11ee8555c0cf276d646d45"
download_tar "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.42/pcre2-10.42.tar.bz2" \
    "$SRC/pcre2" \
    "8d36cd8cb6ea2a4c2bb358ff6411b0c788633a2a45dabbf1aeb4b701d1b5e840"
download_tar "https://download.gnome.org/sources/glib/2.76/glib-2.76.3.tar.xz" \
  "$SRC/glib" \
  "c0be444e403d7c3184d1f394f89f0b644710b5e9331b54fa4e8b5037813ad32a"
download_tar "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.42/pcre2-10.42.tar.bz2" \
    "$SRC/pcre2" \
    "8d36cd8cb6ea2a4c2bb358ff6411b0c788633a2a45dabbf1aeb4b701d1b5e840"
download_tar https://boostorg.jfrog.io/artifactory/main/release/1.83.0/source/boost_1_83_0.tar.bz2 \
    "$SRC/boost" \
    "6478edfe2f3305127cffe8caf73ea0176c53769f4bf1585be237eb30798c3b8e"
download_tar https://downloads.sourceforge.net/project/libjpeg-turbo/3.0.0/libjpeg-turbo-3.0.0.tar.gz \
    "$SRC/libjpeg-turbo" \
    "c77c65fcce3d33417b2e90432e7a0eb05f59a7fff884022a9d931775d583bfaa"
download_tar https://downloads.sourceforge.net/project/freetype/freetype2/2.13.2/freetype-2.13.2.tar.xz \
    "$SRC/freetype" \
    "12991c4e55c506dd7f9b765933e62fd2be2e06d421505d7950a132e4f1bb484d"
download_tar https://downloads.sourceforge.net/project/libpng/libpng16/1.6.40/libpng-1.6.40.tar.xz \
    "$SRC/libpng" \
    "535b479b2467ff231a3ec6d92a525906fb8ef27978be4f66dbe05d3f3a01b3a1"
download_tar https://github.com/libsdl-org/SDL/releases/download/release-2.28.3/SDL2-2.28.3.tar.gz \
    "$SRC/SDL2" \
    "7acb8679652701a2504d734e2ba7543ec1a83e310498ddd22fd44bf965eb5518"
download_tar "http://fresh-center.net/linux/misc/zlib-1.3.tar.gz" \
    "$SRC/zlib" \
    "ff0ba4c292013dbc27530b3a81e1f9a813cd39de01ca5e0f8bf355702efa593e"
download_tar "https://github.com/OpenMW/osg/archive/e65f47c4ab3a0b53cc19f517961671e5f840a08d.zip" \
    "$SRC/osg" \
    "a46dd4e3999985c2377dc9fdc0c5b37f41279f6aa95ae304de3e023cbb8b2cd6"
download_tar "https://github.com/rdiankov/collada-dom/archive/v2.5.0.tar.gz" \
    "$SRC/collada-dom" \
    "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
download_tar "https://openal-soft.org/openal-releases/openal-soft-1.23.1.tar.bz2" \
    "$SRC/openal" \
    "796f4b89134c4e57270b7f0d755f0fa3435b90da437b745160a49bd41c845b21"
download_tar "https://github.com/bulletphysics/bullet3/archive/refs/tags/3.25.tar.gz" \
    "$SRC/bullet" \
    "c45afb6399e3f68036ddb641c6bf6f552bf332d5ab6be62f7e6c54eda05ceb77"

# download_tar "https://ffmpeg.org/releases/ffmpeg-6.0.tar.xz" \
#     "$SRC/ffmpeg" \
#     "57be87c22d9b49c112b6d24bc67d42508660e6b718b3db89c44e47e289137082"
download_tar "https://ffmpeg.org/releases/ffmpeg-5.1.4.tar.xz" \
    "$SRC/ffmpeg" \
    "54383bb890a1cd62580e9f1eaa8081203196ed53bde9e98fb6b0004423f49063"

download_tar "https://download.qt.io/official_releases/qt/5.15/5.15.10/single/qt-everywhere-opensource-src-5.15.10.tar.xz" \
    "$SRC/qt5" \
    "b545cb83c60934adc9a6bbd27e2af79e5013de77d46f5b9f5bb2a3c762bf55ca"

clone "https://github.com/lz4/lz4.git" "$SRC/lz4" "$LZ4_TAG"
clone "https://github.com/LuaJIT/LuaJIT.git" "$SRC/luajit" "$LUAJIT_TAG"
clone "https://github.com/MyGUI/mygui" "$SRC/mygui" "$MYGUI_TAG"
clone "http://github.com/lz4/lz4" "$SRC/lz4" "$LZ4_TAG"
clone "https://github.com/twogood/unshield" "$SRC/unshield" "$UNSHIELD_TAG"
clone "https://github.com/TES3MP/CrabNet" "$SRC/raknet" "$RAKNET_HASH"
clone "https://github.com/TES3MP/CoreScripts.git" "$SRC/CoreScripts" "$CORESCRIPTS_TAG"
clone "https://github.com/TES3MP/TES3MP.git" "$SRC/TES3MP" "$TES3MP_VERSION"

# A hacky fix to TES3MP compilation with Clang on macOS.
pushd "$SRC/TES3MP"
"$SED" -i 's|!defined(__clang__) && ||g' "./apps/openmw-mp/Script/Types.hpp"
"$SED" -i "/Settings::Manager mgr;/i #ifdef __APPLE__\nboost::filesystem::path binary_path = boost::filesystem::system_complete(boost::filesystem::path(argv[0]));\nboost::filesystem::current_path(binary_path.parent_path());\n#endif" ./apps/{browser,openmw-mp}/main.cpp
# Fix the odd path separator used for macOS paths.
"$SED" -i "/#define _SEP_ ':'/c\#define _SEP_ '/'" components/openmw-mp/Utils.cpp
popd

# Fix for an MWSound infinite loop.
pushd "$SRC/TES3MP"
curl -o mwsound-fix.patch https://github.com/OpenMW/openmw/commit/c5cdb0c27797281dfde72761baf2cc6554a86189.patch
splitdiff -a mwsound-fix.patch 
grep -L CHANGELOG mwsound-fix.patch.*.patch | xargs patch -i
popd

# A fix for Qt with Xcode 15. (Will be fixed in Xcode 15.1).
pushd "$SRC/qt5"
curl -o qt5-qmake-xcode15.patch https://raw.githubusercontent.com/Homebrew/formula-patches/086e8cf/qt5/qt5-qmake-xcode15.patch
patch -p1 < qt5-qmake-xcode15.patch
curl -o fffd3d.diff https://github.com/crystalidea/qt-build-tools/commit/fffd3d4b0a628dd780ff8cd553e8f8dc9c66c2ab.diff
patch -p2 < fffd3d.diff 
popd