#!/usr/bin/env zsh
# set -e
. ./_common.sh

run_in_sandbox() {
  sandbox-exec -f "$BUILD_SB" -D TMPDIR="$TMPDIR" -D HOME="$HOME" \
    -D SRC="$PWD" -D BUILD="$PWD" -D INSTALLROOTROOT="$LIB" \
    -D INSTALLROOT="$PCRE2_DIR" "$@"
}

pushd "$SRC/pcre2"

CFLAGS="-arch x86_64 -arch arm64" \
CXXFLAGS="-arch x86_64 -arch arm64" \
    run_in_sandbox ./configure --disable-debug --disable-dependency-tracking \
        --prefix="$PCRE2_DIR" --disable-static --enable-pcre2-16
if [ $? -ne 0 ]; then
    echo "Configure failed, printing config.log..."
    cat config.log
fi
run_in_sandbox make -j$(sysctl -n hw.logicalcpu)
run_in_sandbox make -j1 install
popd
