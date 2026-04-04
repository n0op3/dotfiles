filter=""
if identify ~/.cache/current_wallpaper | grep GIF; then
    filter="--filter Nearest"
fi

transition="center --transition-duration 1"

if [ -f ~/.cache/hyprland-powersave ]; then
    transition=none
fi

swww img "$1" --transition-type $transition $filter

cp "$1" ~/.cache/current_wallpaper
cp "$1" ~/.cache/current_wallpaper.png
cp "$1" ~/.cache/current_wallpaper.jpg
rm ~/.config/rofi/background.png
magick ~/.cache/current_wallpaper.png -resize 1000x400 ~/.config/rofi/background.png # to speed up rofi image loading times if the wallpaper is used in the theme

sleep 1
regen_pywal.sh
