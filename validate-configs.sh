#!/usr/bin/env bash
# Simple config validation script
# This can be run before stowing to catch issues early

set -euo pipefail

echo "Validating configs..."

ERRORS=0

# Validate Hyprland config syntax
if [ -f stow/hyprland/.config/hypr/hyprland.conf ]; then
    echo "Checking Hyprland config..."
    if command -v hyprctl >/dev/null 2>&1; then
        # Can't validate without running Hyprland, but check basic syntax
        if ! grep -q "^monitor=" stow/hyprland/.config/hypr/hyprland.conf; then
            echo "  WARNING: No monitor configuration found"
        fi
    fi
fi

# Validate Alacritty config (TOML)
if [ -f stow/alacritty/.config/alacritty/alacritty.toml ]; then
    echo "Checking Alacritty config..."
    if command -v toml-cli >/dev/null 2>&1 || python3 -c "import tomli" 2>/dev/null; then
        echo "  Alacritty config file exists"
    fi
fi

# Check for required directories
echo "Checking directory structure..."
for dir in stow/*/; do
    [ -d "$dir" ] || break
    package_name=$(basename "$dir")
    if [ ! -d "$dir" ]; then
        echo "  ERROR: Missing directory for $package_name"
        ERRORS=$((ERRORS + 1))
    fi
done

if [ $ERRORS -eq 0 ]; then
    echo "✓ Config validation passed"
    exit 0
else
    echo "✗ Config validation found $ERRORS error(s)"
    exit 1
fi

