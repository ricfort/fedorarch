#!/usr/bin/env bash
set -euo pipefail

# Start hyprpaper and set wallpapers via hyprctl

# Kill any existing instance
killall hyprpaper 2>/dev/null || true

# Start hyprpaper in background
hyprpaper &

# Wait for socket to be ready
sleep 2

# Determine wallpaper path - use theme wallpaper or default
WALLPAPER=""
if [ -f "$HOME/.config/hypr/current_wallpaper" ]; then
    WALLPAPER=$(readlink -f "$HOME/.config/hypr/current_wallpaper")
elif [ -f "$HOME/Pictures/samurailotus.png" ]; then
    WALLPAPER="$HOME/Pictures/samurailotus.png"
elif [ -f "$HOME/Pictures/wallpaper.png" ]; then
    WALLPAPER="$HOME/Pictures/wallpaper.png"
fi

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    echo "Warning: No wallpaper found"
    exit 0
fi

# Preload wallpaper
hyprctl hyprpaper preload "$WALLPAPER" || true

# Set wallpaper for all connected monitors dynamically
if command -v jq >/dev/null 2>&1; then
    hyprctl monitors -j | jq -r '.[].name' | while read -r monitor; do
        hyprctl hyprpaper wallpaper "${monitor},${WALLPAPER}" || true
    done
else
    # Fallback: set for common monitor names
    for monitor in eDP-1 DP-1 DP-2 DP-3 HDMI-A-1 HDMI-A-2; do
        hyprctl hyprpaper wallpaper "${monitor},${WALLPAPER}" 2>/dev/null || true
    done
fi
