#!/bin/sh
rg "$2" "$1" -l | xargs sd "$2" "$3"
