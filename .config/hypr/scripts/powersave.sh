powersave_on() {
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:active_opacity 0.95;\
        keyword decoration:inactive_opacity 0.85;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:rounding 0;\
        keyword decoration:blur:enabled 0;"
    killall swww-daemon
}

powersave_off() {
    hyprctl reload
    pidof swww-daemon || swww-daemon
}

case "$1" in
    "off")
        powersave_off
        rm $HOME/.cache/hyprland-powersave
        notify-send "Powersave deactivated"
        ;;
    "on")
        powersave_on
        touch $HOME/.cache/hyprland-powersave
        notify-send "Powersave activated"
        ;;
    "sync")
        if [ -f $HOME/.cache/hyprland-powersave ]; then
            powersave_on
        else
            powersave_off
        fi
        ;;
    *)
        if [ -f $HOME/.cache/hyprland-powersave ]; then
            $0 off
        else
            $0 on
        fi
        ;;
esac
