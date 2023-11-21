#!/usr/bin/env zsh
set -e
. ./_common.sh

unset LLVM_INSTALL_DIR
unset QMAKEPATH
unset QMAKEFEATURES

pushd "$SRC"
mkdir -p build-qt5
pushd build-qt5
../qt5/configure -recheck-all -verbose -prefix "$QT5_PREFIX" -release -opensource \
    -confirm-license -nomake tools -nomake examples -nomake tests -pkg-config -dbus-runtime \
    -system-freetype -system-libjpeg -system-libpng -system-pcre -system-zlib \
    -no-rpath \
    -skip qt3d -skip qtactiveqt -skip qtandroidextras -skip qtcharts -skip qtconnectivity \
    -skip qtdatavis3d -skip qtdeclarative -skip qtdoc -skip qtgamepad -skip qtgraphicaleffects \
    -skip qtimageformats -skip qtlocation -skip qtlottie -skip qtmacextras -skip qtmultimedia \
    -skip qtnetworkauth -skip qtpurchasing -skip qtquick3d -skip qtquickcontrols -skip qtquickcontrols2 \
    -skip qtquicktimeline -skip qtremoteobjects -skip qtscript -skip qtscxml -skip qtsensors \
    -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtsvg -skip qttools -skip qttranslations \
    -skip qtvirtualkeyboard -skip qtwayland -skip qtwebchannel -skip qtwebengine -skip qtwebglplugin \
    -skip qtwebsockets -skip qtwebview -skip qtwinextras -skip qtx11extras -skip qtxmlpatterns \
    -no-sql-db2 -no-sql-ibase -no-sql-mysql -no-sql-oci -no-sql-odbc -no-sql-psql -no-sql-sqlite \
    -no-sql-tds -no-cups -no-gtk -no-zstd \
    -I "$PNG_ROOT/include" -I "$FREETYPE_DIR/include" \
    -L "$PNG_ROOT/lib" -L "$FREETYPE_DIR/lib" \
    QMAKE_APPLE_DEVICE_ARCHS="x86_64 arm64" \
    QMAKE_CC="$CC" QMAKE_CXX="$CXX"
make -j$(sysctl -n hw.logicalcpu)
make install
popd
popd