#!/usr/bin/env bash
#
# Control audio and microphone using wpctl
#
# Author: Jesse Mirabel <github.com/sejjy>
# Created: August 24, 2025
# License: MIT

get_volume() {
	output=$(wpctl get-volume "$default")
	volume=$(awk '{print ($2 * 100)}' <<<"$output")
}

get_icon() {
	if ((volume == 0)); then
		icon="${prefix}-muted"
	elif ((volume < 33)); then
		icon="${prefix}-low"
	elif ((volume < 66)); then
		icon="${prefix}-medium"
	else
		icon="${prefix}-high"
	fi
}

case $1 in
	'mic')
		default='@DEFAULT_SOURCE@'
		prefix='microphone-sensitivity'
		title='Microphone'
		;;
	'out')
		default='@DEFAULT_SINK@'
		prefix='volume-level'
		title='Volume'
		;;
esac

value=1
case $2 in
	'lower') wpctl set-volume --limit 1.0 "$default" "$value"%- ;;
	'raise') wpctl set-volume --limit 1.0 "$default" "$value"%+ ;;
	*) wpctl set-mute "$default" toggle ;;
esac
