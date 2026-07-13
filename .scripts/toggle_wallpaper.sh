pidof awww-daemon

if [ $? -eq 0 ]; then
    awww kill
    hyprctl keyword decoration:active_opacity 1
    hyprctl keyword decoration:inactive_opacity 1
    mv ~/.cache/current_wallpaper ~/.cache/current_wallpaper.disabled
    mv ~/.cache/current_wallpaper.png ~/.cache/current_wallpaper.png.disabled
    mv ~/.cache/current_wallpaper.jpg ~/.cache/current_wallpaper.jpg.disabled
else
    mv ~/.cache/current_wallpaper.disabled ~/.cache/current_wallpaper
    mv ~/.cache/current_wallpaper.png.disabled ~/.cache/current_wallpaper.png
    mv ~/.cache/current_wallpaper.jpg.disabled ~/.cache/current_wallpaper.jpg
    awww-daemon &
    hyprctl reload
fi
