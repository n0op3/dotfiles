#!/usr/bin/env bash

# Build the list: "wallpaper" first, then all available pywal themes
themes=$(wal --theme 2>/dev/null | grep "-" | awk '{print $2}')
layout=$(printf '%s\n' wallpaper $themes \
    | fzf --prompt="Pywal theme> " --height=40% --reverse)

[[ -z "$layout" ]] && exit 0

if [[ "$layout" == "wallpaper" ]]; then
    regen_pywal.sh -i ~/.cache/current_wallpaper.png > /dev/null 2>&1 & disown
else
    regen_pywal.sh --theme "$layout" > /dev/null 2>&1 & disown
fi
