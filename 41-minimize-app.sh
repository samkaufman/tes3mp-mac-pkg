#!/bin/zsh
set -ex
. ./_common.sh

# Remove Headers folders from frameworks.
find -L testbox/TES3MP.app/Contents/Frameworks/*.framework -name "Headers" \
    -type d -exec rm -rf {} +

# After modifying the link paths in a previous step, it should now be safe to
# remove symlinks to dylibs. Binaries should reference the dylibs directly.
find testbox/TES3MP.app/Contents/Frameworks -name "*.dylib" -type l \
    -exec rm {} \;