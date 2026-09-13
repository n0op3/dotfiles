if ! wal --saturate 0.1 $@; then
    notify-send "Failed to generate color scheme"
    exit 1
fi

swaync-client --reload-css & disown
themecord -p & disown
pywalfox update & disown
pkill .waybar-wrapped && waybar & disown

cp ~/.cache/wal/colors-gtk.css ~/.config/gtk-4.0/gtk.css
cp ~/.cache/wal/colors-gtk.css ~/.config/gtk-3.0/gtk.css
cp ~/.cache/wal/colors-gtk.css ~/.config/gtk-2.0/gtk.css
