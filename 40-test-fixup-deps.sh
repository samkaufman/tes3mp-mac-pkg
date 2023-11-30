#!/bin/zsh
set -ex
. ./_common.sh

readonly OSG_VERSION="3.6.5"

mkdir -p testbox
rm -rf testbox/OpenMW.app
cp -R out/src/TES3MP/build/OpenMW.app testbox/OpenMW.app
mkdir -p testbox/OpenMW.app/Contents/Frameworks
mkdir -p testbox/OpenMW.app/Contents/PlugIns
mkdir -p testbox/OpenMW.app/Contents/PlugIns/osgPlugins-$OSG_VERSION
find out/lib -name "*.dylib" \( -type f -o -type l \) -exec cp -P {} testbox/OpenMW.app/Contents/Frameworks/ \;
find out/lib -name "*.so" \( -type f -o -type l \) -exec cp -P {} testbox/OpenMW.app/Contents/Frameworks/ \;
find out/lib -name "*.framework" -type d -exec cp -R {} testbox/OpenMW.app/Contents/Frameworks/ \;
mv testbox/OpenMW.app/Contents/Frameworks/osgdb_*.so testbox/OpenMW.app/Contents/PlugIns/osgPlugins-$OSG_VERSION
rm testbox/OpenMW.app/Contents/Frameworks/**/libqcocoa.dylib
./40-fixup-deps.py testbox/OpenMW.app testbox/OpenMW.app/Contents/MacOS

# Following isn't fixing up deps, but it is important.
# TODO: Move to other scripts.
mkdir testbox/OpenMW.app/Contents/Resources/server
cp -R "$SRC/CoreScripts" testbox/OpenMW.app/Contents/Resources/server/CoreScripts
cp $SRC/TES3MP/build/*default.cfg testbox/OpenMW.app/Contents/Resources

# Make an icns out of the TES3MP logo which will be referenced by Info.plist.
bake_icns() {
    # Credit to https://github.com/BenSouchet/png-to-icns/tree/main (MIT license).
    sips -z 16 16     "$1" --out "$2/icon_16x16.png" > /dev/null
    sips -z 32 32     "$1" --out "$2/icon_16x16@2x.png" > /dev/null
    sips -z 32 32     "$1" --out "$2/icon_32x32.png" > /dev/null
    sips -z 64 64     "$1" --out "$2/icon_32x32@2x.png" > /dev/null
    sips -z 128 128   "$1" --out "$2/icon_128x128.png" > /dev/null
    sips -z 256 256   "$1" --out "$2/icon_128x128@2x.png" > /dev/null
    sips -z 256 256   "$1" --out "$2/icon_256x256.png" > /dev/null
    sips -z 512 512   "$1" --out "$2/icon_256x256@2x.png" > /dev/null
    sips -z 512 512   "$1" --out "$2/icon_512x512.png" > /dev/null
    sips -z 1024 1024 "$1" --out "$2/icon_512x512@2x.png" > /dev/null
    iconutil -c icns -o "$3" "$2"
}
iconset_temp_dir="$(mktemp -d)/icon.iconset"
mkdir -p "$iconset_temp_dir"
rm -rf "$iconset_temp_dir/*"
bake_icns "out/src/TES3MP/files/tes3mp/tes3mp_logo.png" "$iconset_temp_dir" "testbox/OpenMW.app/Contents/Resources/TES3MP.icns"
rm "testbox/OpenMW.app/Contents/Resources/OpenMW.icns"

cp Info.plist testbox/OpenMW.app/Contents/

# TODO: Update the version number in Info.plist.
"$SED" -i "s/VERSIONHERE/$TES3MP_VERSION/g" testbox/OpenMW.app/Contents/Info.plist

# Update tes3mp-server-default.cfg to look in the app bundle for server scripts.
"$SED" -i '/home = .\/server/c\home = ..\/Resources\/server\/CoreScripts' \
    testbox/OpenMW.app/Contents/Resources/tes3mp-server-default.cfg

# Update the version file TES3MP uses at runtime for compatibility checks.
echo -e $TES3MP_VERSION_FILE > "testbox/OpenMW.app/Contents/Resources/resources/version"

# Copy credits files into the app bundle.
cp out/src/TES3MP/AUTHORS.md testbox/OpenMW.app/Contents/Resources/
cp out/src/TES3MP/tes3mp-credits.md testbox/OpenMW.app/Contents/Resources/

# Rename OpenMW.app to TES3MP.app.
mv testbox/OpenMW.app testbox/TES3MP.app