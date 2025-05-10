#!/bin/sh
set_wallpaper.sh $wallpapers_path/arch/$(find $wallpapers_path -type f | shuf -n 1)
curl --location https://pic.re/image -o ~/.cache/random_wallpaper.png
set_wallpaper.sh ~/.cache/random_wallpaper.png
