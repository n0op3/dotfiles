pidof awww-daemon

if [ $? -eq 0 ]; then
    awww kill
    hyprctl keyword decoration:active_opacity 1
    hyprctl keyword decoration:inactive_opacity 1
    mv ~/.cache/current_wallpaper ~/.cache/current_wallpaper.disabled
else
    mv ~/.cache/current_wallpaper.disabled ~/.cache/current_wallpaper
    awww-daemon &
    hyprctl reload
fi
