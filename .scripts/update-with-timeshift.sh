#!/bin/bash
sudo timeshift --create

if command -v paru 2>&1 > /dev/null
then
  paru
  exit 0
fi

if command -v yay 2>&1 > /dev/null
  yay
fi
