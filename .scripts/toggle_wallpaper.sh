#!/bin/sh
pidof swww-daemon
if [ $? -eq 0 ]; then
  swww kill
else
  swww-daemon
fi
