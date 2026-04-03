hyprctl --instance 0 'keyword misc:allow_session_lock_restore 1'
killall -9 hyprlock || exit
hyprctl --instance 0 'dispatch exec swaylock'
