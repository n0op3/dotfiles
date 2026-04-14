#!/usr/bin/env bash

if (( $# != 3)); then
    echo "Usage: replace.sh pattern_to_replace replacement location"
    exit 1
fi

files="$3"

if [ -d "$files" ]; then
    find "$files" -type f -exec sed -i "s/$1/$2/g" {} +
fi

sed -i "s/$1/$2/g" $files
