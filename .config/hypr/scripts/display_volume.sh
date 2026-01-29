notify-send -h string:x-canonical-private-synchronous:volume "Volume: $(wpctl get-volume @DEFAULT_SINK@ | awk '{print int($2 * 100)}')%"
