#!/usr/bin/env zsh
set -e
. ./_common.sh

readonly wd="$PWD"

pushd "$SRC/glib"

# -Dc_args="-arch $1 -I\"$PCRE2_DIR/include\" -I\"$ICONV_DIR/include\" -I\"$GETTEXT_DIR/include\"" \
build_glib_arch() {
    meson setup _build-$1 \
        --reconfigure \
        --cross-file "$wd/meson-mac-$1.txt" \
        --prefix "$GLIB_DIR/$1/glib" --libdir "$GLIB_DIR/$1/glib/lib" \
        --localstatedir="$OUT/var" -Druntime_dir="$OUT/var/run" \
        --buildtype=release --default-library=both \
        -Dgio_module_dir="$GLIB_DIR/$1/gio/module" -Ddtrace=false -Dtests=false \
        -Dc_args="-arch $1 -I\"$PCRE2_DIR/include\" -I\"$GETTEXT_DIR/include\"" \
        -Dbsymbolic_functions=false
    meson compile -C _build-$1
    meson install -C _build-$1
}

(
    # export PATH="$PCRE2_DIR/bin:$ICONV_DIR/bin:$GETTEXT_DIR/bin:$PATH"
    export PATH="$PCRE2_DIR/bin:$GETTEXT_DIR/bin:$PATH"
    export PKG_CONFIG_PATH="$PCRE2_DIR/lib/pkgconfig:$PKG_CONFIG_PATH"
    # export LIBRARY_PATH="$ICONV_DIR/lib:$GETTEXT_DIR/lib:$LIBRARY_PATH"
    export LIBRARY_PATH="$GETTEXT_DIR/lib:$LIBRARY_PATH"
    build_glib_arch arm64
    build_glib_arch x86_64
)
universalize_install_dirs "$GLIB_DIR/universal/glib" "$GLIB_DIR/arm64/glib" "$GLIB_DIR/x86_64/glib"
mv "$GLIB_DIR/arm64/glib/include" "$GLIB_DIR/universal/glib/include"
# mv "$GLIB_DIR/arm64/glib/glib-2.0" "$GLIB_DIR/universal/glib/glib-2.0"

popd