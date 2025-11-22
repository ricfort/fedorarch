#!/usr/bin/env bash
# Clipboard history menu (Omarchy 3.0 approach)
# Uses cliphist for history, tofi for menu
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

if [ -z "$clipboard_list" ]; then
    notify-send "Clipboard" "Clipboard history is empty" --urgency=normal --expire-time=2000 2>/dev/null
    exit 0
fi

# Show menu and get selection
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

# If selection made: copy to clipboard and paste (Omarchy 3.0 style)
if [ -n "$selection" ]; then
    # Store window before opening menu (for refocusing after selection)
    PREV_WINDOW=""
    if command -v hyprctl >/dev/null 2>&1; then
        PREV_WINDOW=$(hyprctl activewindow -j 2>/dev/null | grep -o '"address":[^,]*' | cut -d'"' -f4)
    fi
    
    # Decode and copy to clipboard
    CLIPBOARD_TEXT=$(echo "$selection" | cliphist decode 2>/dev/null)
    if [ -z "$CLIPBOARD_TEXT" ]; then
        CLIPBOARD_TEXT="$selection"
    fi
    printf '%s' "$CLIPBOARD_TEXT" | wl-copy
    
    # Refocus previous window
    if [ -n "$PREV_WINDOW" ]; then
        hyprctl dispatch focuswindow "address:$PREV_WINDOW" 2>/dev/null
        sleep 0.05
    fi
    
    # Trigger paste using the paste script
    if [ -f ~/.local/bin/clipboard-paste.sh ]; then
        ~/.local/bin/clipboard-paste.sh
    fi
fi
