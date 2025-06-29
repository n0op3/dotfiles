#!/bin/sh
if uwsm check is-active ; then
    uwsm stop
else
    hyprctl dispatch exit
fi
