#!/usr/bin/env bash

echo -en "\0prompt\x1fPywal theme\n"
echo -en "\0no-custom\x1f\n"

STATE="${ROFI_INFO:-main}"

# Convert kebab-case to Title Case
to_title() {
    local IFS='-' out="" w
    for w in $1; do
        out+="${w^} "
    done
    printf '%s' "${out% }"
}

if [[ "$STATE" == "main" ]]; then
    echo -en "Wallpaper\0info\x1fwallpaper\n"
    for theme in $(wal --theme | grep "-" | awk '{print $2}')
    do
        echo -en "$(to_title "$theme")\0info\x1f$theme\n"
    done
else
    if [[ "$1" == "Wallpaper" ]]; then
        regen_pywal.sh -i ~/.cache/current_wallpaper.png > /dev/null 2>&1 & disown
    else
        regen_pywal.sh --theme "$ROFI_INFO" > /dev/null 2>&1 & disown
    fi
    exit
fi
