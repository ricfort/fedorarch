#!/usr/bin/env bash
set +e
set -u

if ! command -v cliphist >/dev/null 2>&1; then
    notify-send "Clipboard" "cliphist is not installed" --urgency=critical 2>/dev/null
    exit 1
fi

if ! command -v tofi >/dev/null 2>&1; then
    notify-send "Clipboard" "tofi is not installed" --urgency=critical 2>/dev/null
    exit 1
fi

if ! command -v wl-copy >/dev/null 2>&1; then
    notify-send "Clipboard" "wl-copy is not installed" --urgency=critical 2>/dev/null
    exit 1
fi

# Get clipboard history
clipboard_list=$(cliphist list 2>/dev/null)

# Check if clipboard is empty
if [ -z "$clipboard_list" ]; then
    notify-send "Clipboard" "Clipboard history is empty" --urgency=normal --expire-time=2000 2>/dev/null
    exit 0
fi

# Show menu with tofi
selection=$(echo "$clipboard_list" | tofi --prompt-text="󰨸 " \
    --width=50% --height=50% \
    --anchor=center \
    --font="CaskaydiaCove Nerd Font" \
    --font-size=14 \
    --background-color="#1a1612e6" \
    --text-color="#d4c4b0" \
    --prompt-color="#d4a574" \
    --selection-color="#1a1612" \
    --selection-background="#d4a574" \
    --border-color="#d4a574" \
    --outline-color="#5c4a3a" \
    --border-width=2 \
    --outline-width=2 \
    --padding-top=60 --padding-left=60 --padding-right=60 --padding-bottom=60 \
    --result-spacing=16 \
    --num-results=15 2>/dev/null)

# If selection was made, copy it to clipboard
if [ -n "$selection" ]; then
    echo "$selection" | cliphist decode | wl-copy
    # Optionally send a notification
    notify-send "Clipboard" "Copied to clipboard" --urgency=low --expire-time=1000 2>/dev/null &
fi
