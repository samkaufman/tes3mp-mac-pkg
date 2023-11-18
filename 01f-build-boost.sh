#!/usr/bin/env zsh
set -ex
. ./_common.sh

pushd "$SRC/boost"
rm -rf arm64 x86_64 universal stage bin.v2
rm -f b2 project-config* || true
./bootstrap.sh \
    --with-libraries=atomic,filesystem,iostreams,program_options,system \
    cxxflags="-arch x86_64 -arch arm64" cflags="-arch x86_64 -arch arm64" \
    linkflags="-arch x86_64 -arch arm64" \
    "--prefix=$BOOST_ROOT"
./b2 headers
./b2 toolset=clang-darwin target-os=darwin architecture=arm abi=aapcs \
    cxxflags="-arch x86_64 -arch arm64" cflags="-arch x86_64 -arch arm64" \
    linkflags="-arch x86_64 -arch arm64" \
    "--prefix=$BOOST_ROOT" -j$(sysctl -n hw.logicalcpu) \
    -a -sNO_ZSTD=1 -sNO_LZMA=1 install
popd