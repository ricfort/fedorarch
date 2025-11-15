#!/bin/bash
# Prepare wallpapers at exact monitor resolutions for best quality

SOURCE="$HOME/Pictures/samurailotus.png"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

mkdir -p "$WALLPAPER_DIR"

# Create wallpapers for each monitor at exact resolution
# DP-3 and DP-1: 2560x1440
convert "$SOURCE" -resize 2560x1440^ -gravity center -extent 2560x1440 -quality 95 "$WALLPAPER_DIR/samurailotus-2560x1440.png"

# eDP-1: 1920x1200
convert "$SOURCE" -resize 1920x1200^ -gravity center -extent 1920x1200 -quality 95 "$WALLPAPER_DIR/samurailotus-1920x1200.png"

echo "Wallpapers prepared at:"
echo "  - $WALLPAPER_DIR/samurailotus-2560x1440.png (for DP-3 and DP-1)"
echo "  - $WALLPAPER_DIR/samurailotus-1920x1200.png (for eDP-1)"

