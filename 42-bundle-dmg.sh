#!/bin/zsh
set -ex
. ./_common.sh

create-dmg --volname "TES3MP-$TES3MP_VERSION" \
    --window-size 800 400 \
    --icon "TES3MP.app" 200 190 \
    --app-drop-link 600 185 \
    --hdiutil-verbose \
    TES3MP-$TES3MP_VERSION.dmg ./testbox