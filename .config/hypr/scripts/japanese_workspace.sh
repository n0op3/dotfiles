#/bin/sh
hyprctl dispatch focusworkspaceoncurrentmonitor 10
sleep 1; anki &
sleep 1; exec "$1" \
    https://jisho.org \
    https://kanji.sljfaq.org &
