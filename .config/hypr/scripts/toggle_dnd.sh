#!/bin/bash

if [ "$(makoctl mode)" == "default" ]; then
    notify-send "DND on"
    sleep 0.5
    makoctl mode -a do-not-disturb
else
    makoctl mode -r do-not-disturb
    notify-send "DND off"
fi
