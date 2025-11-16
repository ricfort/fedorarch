#!/usr/bin/env bash
# Unified clipboard copy - copies primary selection to clipboard
# This ensures clipboard is always synced with primary selection

# Try to copy from primary selection if available
if wl-paste --primary >/dev/null 2>&1; then
    # Copy primary selection to clipboard
    wl-paste --primary | wl-copy
    # The clipboard will be automatically stored by cliphist via wl-paste --watch
else
    # If no primary selection, just ensure clipboard persistence
    # This is handled by wl-clip-persist in hyprland.conf
    :
fi

