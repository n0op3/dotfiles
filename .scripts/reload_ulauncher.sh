#!/bin/bash
killall ulauncher 
ln -sf ~/.cache/wal/template.css ~/.config/ulauncher/user-themes/pywal-ulauncher-theme
start-stop-daemon --start ulauncher &
