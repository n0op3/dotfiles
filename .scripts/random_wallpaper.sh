#!/bin/sh
set_wallpaper.sh $(find -L $wallpapers_path -type f | shuf -n 1)
