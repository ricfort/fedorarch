#!/usr/bin/env bash
set -euo pipefail

# Prepare wallpapers at monitor resolutions for best quality
# This script auto-detects connected monitors and generates wallpapers

SOURCE="$HOME/Pictures/samurailotus.png"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

if [ ! -f "$SOURCE" ]; then
    echo "Error: Source wallpaper not found at $SOURCE"
    echo "Please place your wallpaper at $SOURCE"
    exit 1
fi

if ! command -v convert >/dev/null 2>&1; then
    echo "Error: ImageMagick (convert command) is required but not installed"
    echo "Install with: sudo dnf install ImageMagick"
    exit 1
fi

mkdir -p "$WALLPAPER_DIR"

# Auto-detect monitor resolutions if hyprctl is available
if command -v hyprctl >/dev/null 2>&1 && pgrep -x "Hyprland" >/dev/null 2>&1; then
    echo "Auto-detecting monitor resolutions..."
    
    # Get unique resolutions from connected monitors
    resolutions=$(hyprctl monitors -j | jq -r '.[].width + "x" + .[].height' | sort -u)
    
    if [ -z "$resolutions" ]; then
        echo "Warning: Could not detect monitor resolutions, using common defaults"
        resolutions="1920x1080 2560x1440"
    fi
else
    # Use common default resolutions if Hyprland is not running
    echo "Using common default resolutions..."
    resolutions="1920x1080 1920x1200 2560x1440 3840x2160"
fi

# Generate wallpapers for each unique resolution
echo "Generating wallpapers..."
for res in $resolutions; do
    output="$WALLPAPER_DIR/samurailotus-${res}.png"
    echo "  Creating ${res} wallpaper..."
    
    width=$(echo "$res" | cut -d'x' -f1)
    height=$(echo "$res" | cut -d'x' -f2)
    
    convert "$SOURCE" -resize "${width}x${height}^" -gravity center -extent "${width}x${height}" -quality 95 "$output"
    echo "    ✓ $output"
done

echo ""
echo "Wallpapers prepared in: $WALLPAPER_DIR"

