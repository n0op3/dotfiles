#!/usr/bin/env bash

echo -en "\0prompt\x1fSwitch layout\n"
echo -en "\0no-custom\x1f\n"

STATE="${ROFI_INFO:-main}"

if [[ "$STATE" == "main" ]]; then
    for layout in scrolling master monocle dwindle 
    do
        echo -en "$layout\0info\x1f$layout\n"
    done
        echo -en "reset all\0info\x1freset all\n"
else
    if [[ "$1" == "reset all" ]]; then
        hyprctl eval \
        "for _, workspace in ipairs(hl.get_workspaces()) do \
            hl.workspace_rule({ workspace = tostring(workspace.id), layout = hl.get_config('general.layout') }) \
        end" \
        > /dev/null
        notify-send Hyprland "Reset all layouts."
    else
        hyprctl eval "hl.workspace_rule({ workspace = tostring(hl.get_active_workspace().id), layout = \"$1\" })" > /dev/null
        notify-send Hyprland "Layout changed to $1."
    fi

    exit
fi
