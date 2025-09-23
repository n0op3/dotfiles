#!/bin/bash

if [ $(pidof mako) ]; then
    notify-send "DND on"
    sleep 1
    killall mako
else
    mako &
    sleep 0.1
    notify-send "DND off"
fi
