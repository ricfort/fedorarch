#!/usr/bin/env bash
set -euo pipefail

# Install Japanese Paper Theme for Chromium
# This script installs the theme as a Chromium extension

THEME_DIR="$HOME/.config/chromium/Default/Extensions/japanese-paper-theme"
MANIFEST_FILE="$THEME_DIR/manifest.json"

echo "Installing Japanese Paper Theme for Chromium..."

# Create theme directory
mkdir -p "$THEME_DIR"

# Try to find the manifest in common locations
FOUND=false

# Try in user's home directory (common installation location)
for dir in "$HOME"/*; do
    STOW_MANIFEST="$dir/stow/chromium/.config/chromium/Default/Extensions/japanese-paper-theme/manifest.json"
    if [ -f "$STOW_MANIFEST" ]; then
        cp "$STOW_MANIFEST" "$MANIFEST_FILE"
        echo "Theme manifest copied from $dir"
        FOUND=true
        break
    fi
done

# Try relative paths
if [ "$FOUND" = false ] && [ -f "./stow/chromium/.config/chromium/Default/Extensions/japanese-paper-theme/manifest.json" ]; then
    cp "./stow/chromium/.config/chromium/Default/Extensions/japanese-paper-theme/manifest.json" "$MANIFEST_FILE"
    echo "Theme manifest copied from local stow directory"
    FOUND=true
fi

if [ "$FOUND" = false ]; then
    echo "Error: Theme manifest not found. Please ensure the stow directory is set up correctly."
    echo "Searched in: $HOME/*/stow/chromium/"
    exit 1
fi

echo ""
echo "Theme installed! To activate it:"
echo "1. Open Chromium"
echo "2. Go to chrome://extensions/"
echo "3. Enable 'Developer mode' (top right)"
echo "4. Click 'Load unpacked'"
echo "5. Select: $THEME_DIR"
echo ""
echo "Or restart Chromium and the theme should be detected automatically."

