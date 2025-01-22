#!/bin/sh
swww img $1 --transition-type center --transition-duration 0.5 --transition-fps 30
cp $1 ~/.cache/current_wallpaper.png
cp $1 ~/.config/rofi/background.png
rm ~/.cache/wal
wal -i ~/.cache/current_wallpaper.png --saturate 0.9
