#!/usr/bin/env bash

echo -en "\0prompt\x1fSwitch layout\n"
echo -en "\0no-custom\x1f\n"

STATE="${ROFI_INFO:-main}"

if [[ "$STATE" == "main" ]]; then
    for layout in scrolling master monocle dwindle 
    do
        echo -en "$layout\0info\x1f$layout\n"
    done
else
    hyprctl eval "hl.workspace_rule({ workspace = tostring(hl.get_active_workspace().id), layout = \"$1\" })" > /dev/null
    notify-send Hyprland "Layout changed to $1."
    exit
fi
