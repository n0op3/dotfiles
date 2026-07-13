if [[ $# -eq 0 ]]; then
    exit
fi

filter=""
if identify ~/.cache/current_wallpaper | grep GIF; then
    filter="--filter Nearest"
fi

transition="random --transition-duration 0.5"

if [ -f ~/.cache/hyprland-powersave ]; then
    transition=none
fi

awww img "$1" --transition-type $transition $filter

SUFFIX=""

pidof awww-daemon
if [ $? -eq 1 ]; then
    SUFFIX=".disabled"
fi
 
cp "$1" ~/.cache/current_wallpaper$SUFFIX
cp "$1" ~/.cache/current_wallpaper.png$SUFFIX
cp "$1" ~/.cache/current_wallpaper.jpg$SUFFIX
rm ~/.config/rofi/background.png
magick ~/.cache/current_wallpaper.png -resize 1000x400 ~/.config/rofi/background.png # to speed up rofi image loading times if the wallpaper is used in the theme

sleep 1
regen_pywal.sh
