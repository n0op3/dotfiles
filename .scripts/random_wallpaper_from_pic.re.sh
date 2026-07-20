#!/bin/env bash
awww kill
curl --location https://pic.re/image -o ~/.cache/random_wallpaper.png
awww-daemon &
set_wallpaper.sh ~/.cache/random_wallpaper.png
