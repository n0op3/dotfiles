#!/bin/bash
if [ -f "$HOME/.cache/pywal_on" ]; then
    rm ~/.cache/pywal_on
    rm -rf ~/.cache/wal
else
    regen_pywal.sh
    touch ~/.cache/pywal_on
fi

hyprctl reload
