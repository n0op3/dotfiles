#!/bin/sh
name=$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM
cp ~/.cache/random_wallpaper.png "$wallpapers_path/$name.png"
notify-send "Saved the wallpaper as $name"
