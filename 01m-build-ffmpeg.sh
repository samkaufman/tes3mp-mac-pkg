#!/usr/bin/env zsh
set -ex
. ./_common.sh

run_in_sandbox() {
  sandbox-exec -f "$BUILD_SB" -D TMPDIR="$TMPDIR" -D HOME="$HOME" \
    -D SRC="$PWD" -D BUILD="$PWD" -D INSTALLROOTROOT="$LIB" \
    -D INSTALLROOT="$FFMPEG_DIR" "$@"
}

readonly CONFIG_ARGS=(
    --extra-ldflags="-Wl,-ld_classic"
    --enable-cross-compile
    --enable-gpl --enable-shared --disable-static
    --enable-pthreads --enable-version3 --disable-ffplay --disable-doc
    --enable-videotoolbox --enable-audiotoolbox
    --disable-vdpau --disable-xlib
    --disable-network --disable-libjack --disable-indev=jack)

# Build x86 in another directory.
[[ -d "$SRC/ffmpeg-x86" ]] || cp -R "$SRC/ffmpeg" "$SRC/ffmpeg-x86"
pushd "$SRC/ffmpeg-x86"
./configure --prefix="$FFMPEG_DIR/x86" "${CONFIG_ARGS[@]}" --arch=x86_64 \
    --cc="$CC -arch x86_64"
run_in_sandbox make clean
run_in_sandbox make -j$(sysctl -n hw.logicalcpu) V=1
run_in_sandbox make install
popd

# # Build ARM in another directory.
[[ -d "$SRC/ffmpeg-arm64" ]] || cp -R "$SRC/ffmpeg" "$SRC/ffmpeg-arm64"
pushd "$SRC/ffmpeg-arm64"
./configure --prefix="$FFMPEG_DIR" "${CONFIG_ARGS[@]}" --arch=arm64 \
    --cc="$CC -arch arm64" --enable-neon
run_in_sandbox make clean
run_in_sandbox make -j$(sysctl -n hw.logicalcpu)
run_in_sandbox make install
popd

# Merge binaries
universalize_install_dirs "$FFMPEG_DIR" "$FFMPEG_DIR/x86" "$FFMPEG_DIR"
# cp -R "$FFMPEG_DIR/arm64/include" "$FFMPEG_DIR/"
# rm -rf "$FFMPEG_DIR/arm64"
# rm -rf "$FFMPEG_DIR/x86"