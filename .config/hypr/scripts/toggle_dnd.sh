#!/bin/bash

if [ $(pidof hyprnotify) ]; then
    notify-send "DND on"
    sleep 1
    killall hyprnotify
else
    hyprnotify -s &
    sleep 0.1
    notify-send "DND off"
fi
