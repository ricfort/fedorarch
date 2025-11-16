#!/usr/bin/env bash
# Active window screenshot

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
FILENAME="$SCREENSHOT_DIR/screenshot-window-${TIMESTAMP}.png"

# Get active window geometry using hyprctl
WINDOW_INFO=$(hyprctl activewindow -j 2>/dev/null)
if [ -z "$WINDOW_INFO" ]; then
    notify-send "Screenshot" "No active window found" --urgency=critical --expire-time=2000 2>/dev/null &
    exit 1
fi

# Extract window position and size
X=$(echo "$WINDOW_INFO" | jq -r '.at[0]')
Y=$(echo "$WINDOW_INFO" | jq -r '.at[1]')
W=$(echo "$WINDOW_INFO" | jq -r '.size[0]')
H=$(echo "$WINDOW_INFO" | jq -r '.size[1]')

GEOMETRY="${W}x${H}+${X}+${Y}"

if grim -g "$GEOMETRY" "$FILENAME"; then
    wl-copy < "$FILENAME"
    notify-send "Screenshot" "Window saved and copied to clipboard\n$FILENAME" --urgency=normal --expire-time=2000 2>/dev/null &
else
    notify-send "Screenshot" "Failed to capture window" --urgency=critical --expire-time=2000 2>/dev/null &
    exit 1
fi

