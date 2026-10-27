#!/usr/bin/env bash
if [ -f /tmp/inhibitor.pid ]; then
    kill "$(cat /tmp/inhibitor.pid)" && rm /tmp/inhibitor.pid
    rm /tmp/inhibitor.pid
    notify-send "Inhibitor: off"
else
    systemd-inhibit --what=idle --who="HypridleInhibitor" --why="User requested" --mode=block sleep infinity &
    echo $! > /tmp/inhibitor.pid
    notify-send "Inhibitor: on"
fi
