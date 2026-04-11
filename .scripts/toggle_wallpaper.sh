pidof awww-daemon
if [ $? -eq 0 ]; then
    awww kill
    hyprctl keyword decoration:active_opacity 1
    hyprctl keyword decoration:inactive_opacity 1
else
    awww-daemon &
    hyprctl reload
fi
