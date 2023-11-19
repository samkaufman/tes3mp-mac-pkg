#!/usr/bin/env zsh

set -e

# Run all scripts which begin with an integer in alphanumeric order.
for script in $(ls -1v *.sh | grep '^[0-9]' | sort -n); do
    echo "Running $script"
    ./$script
done