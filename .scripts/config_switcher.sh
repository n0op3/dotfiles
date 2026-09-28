#!/usr/bin/env bash

shopt -s nullglob

# Pick an app that has a configs/ subdirectory
app=$(for dir in ~/.config/*/configs/; do
    dir=${dir%/configs/}
    printf '%s\n' "${dir##*/}"
done | fzf --prompt="Swap config> " --height=40% --reverse --cycle)

[[ -z "$app" ]] && exit 0

# Pick a config (subdir) for that app
config=$(find ~/.config/"$app"/configs -mindepth 1 -maxdepth 1 -type d -printf '%P\n' \
    | fzf --prompt="$app> " --height=40% --reverse --cycle)

[[ -z "$config" ]] && exit 0

# Apply the chosen config
cd ~/.config/"$app" || exit 1
switch_config.sh "$config" > /dev/null 2>&1
cd - > /dev/null || cd "$HOME"

# Restart the app if it's running
process="$(ps -eo comm,args | grep "$app" | head -n 1)"

if [[ "$process" == *" $app"* ]]; then
    to_kill=${process%% *}
    killall "$to_kill"
    setsid -f ${process#* } </dev/null >/dev/null 2>&1 &
fi
