#!/bin/bash
if ! wal -i ~/.cache/current_wallpaper.png --saturate 0.9 --contrast 0; then
    notify-send "Failed to generate color scheme"
    exit 1
fi

walcord # Vesktop theme update
pywalfox update # Refresh firefox theme
