#!/bin/sh
pidof swww-daemon
if [ $? -eq 0 ]; then
    swww kill
    hyprctl keyword decoration:active_opacity 1
    hyprctl keyword decoration:inactive_opacity 1
else
    hyprctl reload
    swww-daemon &
    set_wallpaper.sh ~/.cache/current_wallpaper.png
fi
