#!/bin/sh
ps aux | grep 'set_wallpaper.sh' | grep -v $$ | awk '{print $2}' | xargs kill # Kill other set_wallpapers

swww img $1 --transition-type center --transition-duration 0.25 --transition-fps 30

cp $1 ~/.cache/current_wallpaper.png
cp $1 ~/.config/rofi/background.png

rm ~/.cache/wal
wal -i ~/.cache/current_wallpaper.png --saturate 0.9

walcord # Vesktop theme update
pywalfox update # Refresh firefox theme

# Bar
hyprpanel -q 
start-stop-daemon hyprpanel &

# App launcher
killall ulauncher 
ln -sf ~/.cache/wal/template.css ~/.config/ulauncher/user-themes/pywal-ulauncher-theme
start-stop-daemon ulauncher &

exit
