#!/usr/bin/env zsh

set -e

# Run all scripts which begin with an integer in alphanumeric order.
for script in $(ls -1v *.sh | grep '^[0-9]' | sort -n); do
    if [ "$GITHUB_ACTIONS" == "true" ]; then
        echo "::group::$script"
        echo "Running $script"
    fi
    ./$script
    if [ "$GITHUB_ACTIONS" == "true" ]; then
        echo "::endgroup::"
    fi
done