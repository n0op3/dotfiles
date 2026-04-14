if [ -f "$HOME/.pywal_on" ]; then
    rm ~/.pywal_on
    rm -rf ~/.cache/wal/colors-hyprland.conf
           ~/.cache/wal/colors-alacritty.toml
           ~/.cache/wal/colors-kitty.conf
    mkdir -p ~/.cache/wal
    echo "\$color5 = 0xFF4BE875
          \$color6 = 0xFF85E0F4" > ~/.cache/wal/colors-hyprland.conf
    notify-send "Pywal off"
else
    touch ~/.pywal_on
    ~/.scripts/regen_pywal.sh
    notify-send "Pywal on"
fi

hyprctl reload
