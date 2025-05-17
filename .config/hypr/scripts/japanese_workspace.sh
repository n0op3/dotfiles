#/bin/sh
hyprctl dispatch focusworkspaceoncurrentmonitor 10
sleep 1; anki &
sleep 1; exec "$1" \
    https://jisho.org \
    https://deepl.com \
    https://translate.google.com \
    https://kanji.sljfaq.org &
