#!/usr/bin/env bash
# Unified clipboard copy - copies selected text to clipboard
# Works by copying primary selection (works in most apps) or simulating Ctrl+C

# First, try to copy from primary selection (works in terminals and many apps)
if wl-paste --primary >/dev/null 2>&1; then
    # Copy primary selection to clipboard
    wl-paste --primary | wl-copy
    # The clipboard will be automatically stored by cliphist via wl-paste --watch
    exit 0
fi

# If no primary selection, try to simulate Ctrl+C using wtype
if command -v wtype >/dev/null 2>&1; then
    # Simulate Ctrl+C to copy selected text
    # wtype syntax: -M to press modifier, -P to press key, -m to release modifier
    # Run as a single command sequence
    (wtype -M ctrl && sleep 0.05 && wtype -P c && sleep 0.05 && wtype -m ctrl) 2>/dev/null
    # Small delay to ensure copy completes
    sleep 0.15
elif command -v ydotool >/dev/null 2>&1; then
    # Fallback to ydotool if wtype not available
    ydotool key ctrl+c
    sleep 0.15
else
    # Last resort: notify user
    notify-send "Clipboard" "No text selected\nSelect text and try again" --urgency=low --expire-time=2000 2>/dev/null &
fi
