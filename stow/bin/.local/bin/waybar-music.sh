#!/usr/bin/env bash
set -euo pipefail

# Waybar music widget with animated visualizer
# Uses playerctl to get current track info and displays with animated bars

# Check if playerctl is available
if ! command -v playerctl >/dev/null 2>&1; then
    echo '{"text":"","class":"","tooltip":""}'
    exit 0
fi

# Get player status (suppress errors)
STATUS=$(playerctl status 2>/dev/null || echo "Stopped")

if [ "$STATUS" = "Playing" ] || [ "$STATUS" = "Paused" ]; then
    # Get track info
    ARTIST=$(playerctl metadata artist 2>/dev/null || echo "Unknown Artist")
    TITLE=$(playerctl metadata title 2>/dev/null || echo "Unknown Title")
    
    # Truncate if too long
    if [ ${#TITLE} -gt 35 ]; then
        TITLE="${TITLE:0:32}..."
    fi
    
    # Get player name for icon
    PLAYER=$(playerctl --list-all 2>/dev/null | head -1 || echo "")
    if [[ "$PLAYER" == *"spotify"* ]] || [[ "$PLAYER" == *"Spotify"* ]]; then
        ICON="󰓇"
    else
        ICON="󰎄"
    fi
    
    # Create animated visualizer bars (animation using microseconds for smoother effect)
    USEC=$(date +%s%N | cut -b1-13)
    MOD=$((USEC % 800 / 200))
    
    # Animated bars that pulse/move
    case $MOD in
        0) BARS="▁▃▅▇" ;;
        1) BARS="▂▅▇▆" ;;
        2) BARS="▃▆▅▃" ;;
        3) BARS="▁▃▅▆" ;;
    esac
    
    if [ "$STATUS" = "Playing" ]; then
        TEXT="${ICON} ${BARS} ${TITLE}"
        CLASS="playing"
    else
        TEXT="${ICON} ⏸ ${TITLE}"
        CLASS=""
    fi
    
    TOOLTIP="${TITLE}\n${ARTIST}"
    
    # Escape JSON properly
    TEXT_ESC=$(echo "$TEXT" | sed 's/"/\\"/g')
    TOOLTIP_ESC=$(echo "$TOOLTIP" | sed 's/"/\\"/g' | sed 's/$/\\n/' | tr -d '\n' | sed 's/\\n$//')
    
    echo "{\"text\":\"${TEXT_ESC}\",\"class\":\"${CLASS}\",\"tooltip\":\"${TOOLTIP_ESC}\"}"
else
    echo '{"text":"","class":"","tooltip":""}'
fi

