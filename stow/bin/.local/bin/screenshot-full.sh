#!/usr/bin/env bash
set -euo pipefail

# Full screen screenshot

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
FILENAME="$SCREENSHOT_DIR/screenshot-${TIMESTAMP}.png"

if grim "$FILENAME"; then
    wl-copy < "$FILENAME"
    notify-send "Screenshot" "Full screen saved and copied to clipboard\n$FILENAME" --urgency=normal --expire-time=2000 2>/dev/null &
else
    notify-send "Screenshot" "Failed to take screenshot" --urgency=critical --expire-time=2000 2>/dev/null &
    exit 1
fi

