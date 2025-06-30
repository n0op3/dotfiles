#!/bin/bash
if [ -f "$HOME/.cache/pywal_on" ]; then
    rm ~/.cache/pywal_on
    rm -rf ~/.cache/wal/colors-hyprland.conf
           ~/.cache/wal/colors-alacritty.toml
           ~/.cache/wal/colors-kitty.conf
    mkdir -p ~/.cache/wal
    echo "\$color1 = 0xFF4BE875
          \$color4 = 0xFF85E0F4" > ~/.cache/wal/colors-hyprland.conf
    notify-send "Pywal off"
else
    ~/.scripts/regen_pywal.sh
    touch ~/.cache/pywal_on
    notify-send "Pywal on"
fi

hyprctl reload
