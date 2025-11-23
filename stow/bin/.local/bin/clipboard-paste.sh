#!/usr/bin/env bash
set -euo pipefail

# Universal paste
# Detects terminal vs GUI apps and uses appropriate paste method

# Detect if active window is a terminal
IS_TERMINAL=false
if command -v hyprctl >/dev/null 2>&1; then
    ACTIVE_CLASS=$(hyprctl activewindow -j 2>/dev/null | grep -o '"class":"[^"]*' | cut -d'"' -f4)
    # Check if it's a terminal (ghostty, alacritty, etc.)
    if echo "$ACTIVE_CLASS" | grep -qiE "(ghostty|alacritty|kitty|foot|wezterm|st|urxvt|xterm)"; then
        IS_TERMINAL=true
    fi
fi

# Try wtype first
if command -v wtype >/dev/null 2>&1; then
    # Release any stuck modifiers
    wtype -m ctrl -m shift -m alt -m super 2>/dev/null
    
    if [ "$IS_TERMINAL" = true ]; then
        # Terminals use Shift+Insert for paste
        wtype -M shift -P Insert -m shift 2>/dev/null
    else
        # GUI apps use Ctrl+V
        wtype -M ctrl -P v -m ctrl 2>/dev/null
    fi
elif command -v ydotool >/dev/null 2>&1; then
    if [ "$IS_TERMINAL" = true ]; then
        ydotool key shift+insert 2>/dev/null
    else
        ydotool key ctrl+v 2>/dev/null
    fi
else
    # Last resort: notify user
    if [ "$IS_TERMINAL" = true ]; then
        notify-send "Clipboard" "Press Shift+Insert to paste" --urgency=low --expire-time=1000 2>/dev/null &
    else
        notify-send "Clipboard" "Press Ctrl+V to paste" --urgency=low --expire-time=1000 2>/dev/null &
    fi
fi

