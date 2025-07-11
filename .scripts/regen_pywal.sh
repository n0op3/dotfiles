#!/bin/bash
if [ ! -f ~/.pywal_on ]; then
    exit 1
fi

if ! wal -i ~/.cache/current_wallpaper.png --saturate 0.4 --contrast 5; then
    notify-send "Failed to generate color scheme"
    exit 1
fi

walcord # Vesktop theme update
pywalfox update # Refresh firefox theme
killall syshud && syshud -o v -p right # Reload the OSD
