#!/usr/bin/env bash

# Pick a layout with fzf
layout=$(printf '%s\n' scrolling master monocle dwindle "reset all" \
    | fzf --prompt="Switch layout> " --height=40% --reverse)

[[ -z "$layout" ]] && exit 0

if [[ "$layout" == "reset all" ]]; then
    hyprctl eval \
        "for _, workspace in ipairs(hl.get_workspaces()) do \
            hl.workspace_rule({ workspace = tostring(workspace.id), layout = hl.get_config('general.layout') }) \
        end" \
        > /dev/null
    notify-send Hyprland "Reset all layouts."
else
    hyprctl eval "hl.workspace_rule({ workspace = tostring(hl.get_active_workspace().id), layout = \"$layout\" })" > /dev/null
    notify-send Hyprland "Layout changed to $layout."
fi
