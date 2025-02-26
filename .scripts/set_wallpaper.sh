#!/bin/sh
# ps aux | grep 'set_wallpaper.sh' | grep -v $$ | awk '{print $2}' | xargs kill # Kill other set_wallpapers

swww img $1 --transition-type center --transition-duration 0.25 --transition-fps 30

cp $1 ~/.cache/current_wallpaper.png
cp $1 ~/.cache/current_wallpaper.jpg
cp $1 ~/.cache/current_wallpaper
cp $1 ~/.config/rofi/background.png
