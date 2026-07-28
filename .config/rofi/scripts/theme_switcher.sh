#!/usr/bin/env bash

echo -en "\0prompt\x1fPywal theme\n"
echo -en "\0no-custom\x1f\n"

STATE="${ROFI_INFO:-main}"

if [[ "$STATE" == "main" ]]; then
    echo -en "wallpaper\0info\x1fwallpaper\n"
    for theme in $(wal --theme | grep "-" | awk '{print $2}')
    do
        echo -en "$theme\0info\x1f$theme\n"
    done
else
    if [[ "$1" == "wallpaper" ]]; then
        regen_pywal.sh -i ~/.cache/current_wallpaper.png >/dev/null 2>&1 & disown
    else
        regen_pywal.sh --theme "$1" >/dev/null 2>&1 & disown
    fi
    exit
fi
