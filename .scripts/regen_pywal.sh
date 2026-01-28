if ! wal -i ~/.cache/current_wallpaper.png --saturate 0.4 --contrast 7; then
    notify-send "Failed to generate color scheme"
    exit 1
fi

walcord & disown

pywalfox update & disown

killall syshud
syshud -o v -p right & disown

hyprctl clients | grep -q 'waybar' && pkill waybar
pkill .waybar-wrapped && waybar & disown
