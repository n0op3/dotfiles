#!/usr/bin/env bash
set_wallpaper.sh $(find $wallpapers_path -maxdepth 1 -type f | shuf -n 1)
