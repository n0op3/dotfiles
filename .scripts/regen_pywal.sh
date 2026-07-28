saturation=${1:--0.1}
contrast=${2:-2}

if ! wal -i ~/.cache/current_wallpaper.png --saturate $saturation --contrast $contrast; then
    notify-send "Failed to generate color scheme"
    exit 1
fi

swaync-client --reload-css & disown
themecord -p & disown
pywalfox update & disown

hyprctl clients | grep -q 'waybar' && pkill waybar
pkill .waybar-wrapped && waybar & disown
