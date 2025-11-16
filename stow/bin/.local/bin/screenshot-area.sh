#!/usr/bin/env bash
# Area selection screenshot

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
FILENAME="$SCREENSHOT_DIR/screenshot-area-${TIMESTAMP}.png"

# Use slurp to select area, then grim to capture
if AREA=$(slurp); then
    if grim -g "$AREA" "$FILENAME"; then
        wl-copy < "$FILENAME"
        notify-send "Screenshot" "Area saved and copied to clipboard\n$FILENAME" --urgency=normal --expire-time=2000 2>/dev/null &
    else
        notify-send "Screenshot" "Failed to capture area" --urgency=critical --expire-time=2000 2>/dev/null &
        exit 1
    fi
else
    # User cancelled selection
    exit 0
fi

