#!/bin/bash
if [ -f $HOME/.cache/hyprland-powersave ]; then
    hyprctl reload
    rm $HOME/.cache/hyprland-powersave
    notify-send "Powersave deactivated"
else
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;"
    touch $HOME/.cache/hyprland-powersave
    notify-send "Powersave activated"
fi
