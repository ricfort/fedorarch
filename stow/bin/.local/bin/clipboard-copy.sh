#!/usr/bin/env bash
set -euo pipefail

# Unified clipboard copy - copies selected text to clipboard
# Works with terminals (primary selection) and GUI apps (Ctrl+C)

# Detect if active window is a terminal
IS_TERMINAL=false
if command -v hyprctl >/dev/null 2>&1; then
    ACTIVE_CLASS=$(hyprctl activewindow -j 2>/dev/null | grep -o '"class":"[^"]*' | cut -d'"' -f4)
    # Check if it's a terminal (ghostty, alacritty, etc.)
    if echo "$ACTIVE_CLASS" | grep -qiE "(ghostty|alacritty|kitty|foot|wezterm|st|urxvt|xterm)"; then
        IS_TERMINAL=true
    fi
fi

# For terminals: use primary selection (already works when text is selected)
# For GUI apps: try primary selection first, then fallback to Ctrl+C
if [ "$IS_TERMINAL" = true ]; then
    # Terminals: copy primary selection to clipboard
    if wl-paste --primary >/dev/null 2>&1; then
        PRIMARY_TEXT=$(wl-paste --primary)
        printf '%s' "$PRIMARY_TEXT" | wl-copy
        # Explicitly store in cliphist (watcher might miss it)
        if command -v cliphist >/dev/null 2>&1; then
            printf '%s' "$PRIMARY_TEXT" | cliphist store 2>/dev/null
        fi
        exit 0
    else
        # No primary selection in terminal - notify user
        notify-send "Clipboard" "No text selected\nSelect text in terminal first" --urgency=low --expire-time=2000 2>/dev/null &
        exit 1
    fi
else
    # GUI apps: try primary selection first
    if wl-paste --primary >/dev/null 2>&1; then
        PRIMARY_TEXT=$(wl-paste --primary)
        printf '%s' "$PRIMARY_TEXT" | wl-copy
        # Explicitly store in cliphist
        if command -v cliphist >/dev/null 2>&1; then
            printf '%s' "$PRIMARY_TEXT" | cliphist store 2>/dev/null
        fi
        exit 0
    fi
    
    # If no primary selection, simulate Ctrl+C
    if command -v wtype >/dev/null 2>&1; then
        wtype -M ctrl -P c -m ctrl 2>/dev/null
        sleep 0.15
    elif command -v ydotool >/dev/null 2>&1; then
        ydotool key ctrl+c 2>/dev/null
        sleep 0.15
    else
        notify-send "Clipboard" "No text selected\nSelect text and try again" --urgency=low --expire-time=2000 2>/dev/null &
    fi
fi
