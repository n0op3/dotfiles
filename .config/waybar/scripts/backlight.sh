#!/usr/bin/env bash

case $1 in
	'down') brightnessctl -n set 5%- ;;
	'up') brightnessctl -n set 5%+ ;;
esac

level=$(brightnessctl -m | awk -F',' '{print $4}')
