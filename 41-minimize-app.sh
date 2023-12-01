#!/bin/zsh
set -ex
. ./_common.sh

# Remove Headers folders from frameworks.
# This will print some "No such file or directory" warnings for the aliases,
# but that's fine.
find -L testbox/TES3MP.app/Contents/Frameworks/*.framework -name "Headers" \
    -type d -exec rm -rf {} \;

# After modifying the link paths in a previous step, it should now be safe to
# remove symlinks to dylibs. Binaries should reference the dylibs directly.
find testbox/TES3MP.app/Contents/Frameworks -name "*.dylib" -type l \
    -exec rm {} \;