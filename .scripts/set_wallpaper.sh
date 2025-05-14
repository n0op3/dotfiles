#!/bin/sh
# ps aux | grep 'set_wallpaper.sh' | grep -v $$ | awk '{print $2}' | xargs kill # Kill other set_wallpapers

filter=""
if identify ~/.cache/current_wallpaper | grep GIF; then
    filter="--filter Nearest"
fi

swww img "$1" --transition-type center --transition-duration 0.25 --transition-fps 30 $filter

cp $1 ~/.cache/current_wallpaper.png
cp $1 ~/.cache/current_wallpaper.jpg
cp $1 ~/.cache/current_wallpaper
rm ~/.config/rofi/background.png
magick ~/.cache/current_wallpaper.png -resize 1000x400 ~/.config/rofi/background.png # to speed up rofi image loading times
