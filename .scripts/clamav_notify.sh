VIRUS_NAME="$CLAM_VIRUSEVENT_VIRUSNAME"
FILE_PATH="$CLAM_VIRUSEVENT_FILENAME"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

MESSAGE="[$TIMESTAMP] $VIRUS_NAME was detected at $FILE_PATH!"

LOG_FILE="/var/log/clamav/notifications.log"
echo "$TIMESTAMP - $MESSAGE" >> "$LOG_FILE"
echo "$TIMESTAMP - Detection details logged to $LOG_FILE"

if command -v notify-send &> /dev/null; then
    # Try to send notification to the currently logged-in user
    USER_ID=$(who | awk '{print $1}' | head -1)
    if [ -n "$USER_ID" ]; then
        sudo -u "$USER_ID" DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u "$USER_ID")/bus \
        notify-send -u critical "ClamAV Alert" "$MESSAGE"
        echo "$TIMESTAMP - Desktop notification sent to user $USER_ID." >> "$LOG_FILE"
    else
        echo "$TIMESTAMP - No GUI user logged in, skipping desktop notification." >> "$LOG_FILE"
    fi
else
    echo "$TIMESTAMP - 'notify-send' not found. Install 'libnotify-bin' for desktop alerts." >> "$LOG_FILE"
fi
