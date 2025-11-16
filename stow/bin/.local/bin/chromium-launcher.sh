#!/usr/bin/env bash
set -euo pipefail

# Chromium launcher - optimized for fast startup
# Only does setup work when needed, otherwise launches immediately

VERSIONED_DIR="$HOME/.config/chromium/Default/Extensions/japanese-paper-theme/1.0"
THEME_MANIFEST="$VERSIONED_DIR/manifest.json"
PREFS_FILE="$HOME/.config/chromium/Default/Preferences"

# Fast path: if extension is installed and Preferences exist, launch immediately
if [ -f "$THEME_MANIFEST" ] && [ -f "$PREFS_FILE" ] && grep -q '"toolbar": \[26, 22, 18\]' "$PREFS_FILE" 2>/dev/null; then
    exec chromium-browser --load-extension="$VERSIONED_DIR" "$@"
fi

# Setup path: only runs if extension or theme not set up
THEME_DIR="$HOME/.config/chromium/Default/Extensions/japanese-paper-theme"
mkdir -p "$THEME_DIR"

# Find manifest in stow directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
STOW_MANIFEST="$REPO_ROOT/stow/chromium/.config/chromium/Default/Extensions/japanese-paper-theme/manifest.json"

if [ ! -f "$STOW_MANIFEST" ] && [ -d "$HOME/fedorarch" ]; then
    STOW_MANIFEST="$HOME/fedorarch/stow/chromium/.config/chromium/Default/Extensions/japanese-paper-theme/manifest.json"
fi

# Create manifest if not found
if [ ! -f "$STOW_MANIFEST" ]; then
    mkdir -p "$(dirname "$STOW_MANIFEST")"
    cat > "$STOW_MANIFEST" << 'MANIFEST_EOF'
{
  "manifest_version": 3,
  "name": "Japanese Paper Theme",
  "version": "1.0",
  "description": "Japanese paper theme with aged paper aesthetic",
  "theme": {
    "colors": {
      "frame": [26, 22, 18],
      "frame_inactive": [26, 22, 18],
      "background_tab": [26, 22, 18],
      "toolbar": [26, 22, 18],
      "toolbar_text": [212, 196, 176],
      "toolbar_field": [26, 22, 18],
      "toolbar_field_text": [212, 196, 176],
      "tab_background_text": [212, 196, 176],
      "tab_text": [212, 196, 176],
      "bookmark_text": [212, 196, 176],
      "toolbar_button_icon": [212, 165, 116],
      "ntp_background": [26, 22, 18],
      "ntp_text": [212, 196, 176],
      "ntp_link": [212, 165, 116]
    },
    "tints": {
      "buttons": [0, 0, 0],
      "frame": [0, 0, 0]
    }
  }
}
MANIFEST_EOF
fi

# Copy manifest if needed
if [ -f "$STOW_MANIFEST" ]; then
    if [ ! -f "$THEME_DIR/manifest.json" ] || [ "$STOW_MANIFEST" -nt "$THEME_DIR/manifest.json" ]; then
        cp "$STOW_MANIFEST" "$THEME_DIR/manifest.json"
    fi
fi

# Apply theme to Preferences (only if needed - optimized for speed)
# Create directory if needed
mkdir -p "$(dirname "$PREFS_FILE")"

# Quick check: only run Python if Preferences doesn't exist or theme might be wrong
# This avoids running Python on every launch
if [ ! -f "$PREFS_FILE" ] || ! grep -q '"toolbar": \[26, 22, 18\]' "$PREFS_FILE" 2>/dev/null; then
    if [ ! -f "$PREFS_FILE" ]; then
        echo '{}' > "$PREFS_FILE"
    fi
    
    python3 << 'PYTHON_SCRIPT'
import json
import os

prefs_file = os.path.expanduser("~/.config/chromium/Default/Preferences")

theme_config = {
    "theme": {
        "color": {
            "background_tab": [26, 22, 18],
            "frame": [26, 22, 18],
            "frame_inactive": [26, 22, 18],
            "toolbar": [26, 22, 18],
            "toolbar_text": [212, 196, 176],
            "toolbar_field": [26, 22, 18],
            "toolbar_field_text": [212, 196, 176],
            "toolbar_top_separator": [92, 74, 58],
            "toolbar_vertical_separator": [92, 74, 58],
            "toolbar_bottom_separator": [92, 74, 58],
            "tab_background_text": [212, 196, 176],
            "tab_text": [212, 196, 176],
            "bookmark_text": [212, 196, 176],
            "toolbar_button_icon": [212, 165, 116],
            "toolbar_button_icon_hover": [212, 165, 116],
            "ntp_background": [26, 22, 18],
            "ntp_text": [212, 196, 176],
            "ntp_link": [212, 165, 116],
            "ntp_header": [212, 165, 116],
            "control_background": [26, 22, 18],
            "window_control_background": [26, 22, 18]
        },
        "tint": [0, 0, 0],
        "images": {},
        "properties": {
            "ntp_background_alignment": "center",
            "ntp_background_repeat": "no-repeat"
        }
    }
}

try:
    with open(prefs_file, 'r') as f:
        prefs = json.load(f)
    
    # Update theme
    prefs["theme"] = theme_config["theme"]
    
    with open(prefs_file, 'w') as f:
        json.dump(prefs, f, indent=2)
except Exception:
    try:
        with open(prefs_file, 'w') as f:
            json.dump(theme_config, f, indent=2)
    except Exception:
        pass
PYTHON_SCRIPT
fi

# Install theme extension ONLY on first launch
# Check if already installed by looking for the manifest file
VERSIONED_DIR="$HOME/.config/chromium/Default/Extensions/japanese-paper-theme/1.0"
THEME_MANIFEST="$VERSIONED_DIR/manifest.json"

# Only install if manifest doesn't exist (first launch)
if [ ! -f "$THEME_MANIFEST" ]; then
    # Create extension directory
    mkdir -p "$VERSIONED_DIR"
    
    # Copy manifest from source
    if [ -f "$THEME_DIR/manifest.json" ]; then
        cp "$THEME_DIR/manifest.json" "$THEME_MANIFEST"
    else
        # Create manifest inline if source doesn't exist
        cat > "$THEME_MANIFEST" << 'MANIFEST_EOF'
{
  "manifest_version": 3,
  "name": "Japanese Paper Theme",
  "version": "1.0",
  "description": "Japanese paper theme with aged paper aesthetic",
  "theme": {
    "colors": {
      "frame": [26, 22, 18],
      "frame_inactive": [26, 22, 18],
      "background_tab": [26, 22, 18],
      "toolbar": [26, 22, 18],
      "toolbar_text": [212, 196, 176],
      "toolbar_field": [26, 22, 18],
      "toolbar_field_text": [212, 196, 176],
      "tab_background_text": [212, 196, 176],
      "tab_text": [212, 196, 176],
      "bookmark_text": [212, 196, 176],
      "toolbar_button_icon": [212, 165, 116],
      "ntp_background": [26, 22, 18],
      "ntp_text": [212, 196, 176],
      "ntp_link": [212, 165, 116]
    },
    "tints": {
      "buttons": [0, 0, 0],
      "frame": [0, 0, 0]
    }
  }
}
MANIFEST_EOF
    fi
    
    # Register extension in Preferences (only on first install)
    python3 << 'PYTHON_SCRIPT'
import json
import os

prefs_file = os.path.expanduser("~/.config/chromium/Default/Preferences")

try:
    with open(prefs_file, 'r') as f:
        prefs = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    prefs = {}

# Ensure extensions settings exist
if "extensions" not in prefs:
    prefs["extensions"] = {}

if "settings" not in prefs["extensions"]:
    prefs["extensions"]["settings"] = {}

theme_id = "japanese-paper-theme"
theme_path = os.path.expanduser("~/.config/chromium/Default/Extensions/japanese-paper-theme/1.0")

# Install theme extension (this only runs on first launch)
# Enable the theme extension
prefs["extensions"]["settings"][theme_id] = {
        "creation_flags": 1,
        "granted_permissions": [],
        "location": 1,
        "manifest": {
            "manifest_version": 3,
            "name": "Japanese Paper Theme",
            "theme": {
                "colors": {
                    "frame": [26, 22, 18],
                    "frame_inactive": [26, 22, 18],
                    "background_tab": [26, 22, 18],
                    "toolbar": [26, 22, 18],
                    "toolbar_text": [212, 196, 176],
                    "toolbar_field": [26, 22, 18],
                    "toolbar_field_text": [212, 196, 176],
                    "tab_background_text": [212, 196, 176],
                    "tab_text": [212, 196, 176],
                    "bookmark_text": [212, 196, 176],
                    "toolbar_button_icon": [212, 165, 116],
                    "ntp_background": [26, 22, 18],
                    "ntp_text": [212, 196, 176],
                    "ntp_link": [212, 165, 116]
                },
                "tints": {
                    "buttons": [0, 0, 0],
                    "frame": [0, 0, 0]
                }
            }
        },
        "path": theme_path,
        "state": 1,
    "was_installed_by_default": False,
    "was_installed_by_oem": False
}

# Set as active theme
prefs["extensions"]["theme"] = {
    "id": theme_id,
    "use_system": False
}

with open(prefs_file, 'w') as f:
    json.dump(prefs, f, indent=2)
PYTHON_SCRIPT
fi

# Launch Chromium
# Always ensure theme is loaded - use --load-extension but only update Preferences if needed
# The --load-extension flag is needed for Chromium to recognize the theme extension
exec chromium-browser --load-extension="$VERSIONED_DIR" "$@"

