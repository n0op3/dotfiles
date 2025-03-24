#!/bin/sh
pidof swww-daemon
if [ $? -eq 0 ]; then
  swww kill
else
  swww-daemon &
  set_wallpaper.sh ~/.cache/current_wallpaper.png
fi
