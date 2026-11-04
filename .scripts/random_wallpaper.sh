#!/usr/bin/env bash
set_wallpaper.sh $(find $wallpapers_path -type f | rg "(.png|.jpg)$" | shuf -n 1)
