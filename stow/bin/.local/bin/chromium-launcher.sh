#!/usr/bin/env bash
set -euo pipefail

# Chromium launcher that ensures theme is applied before launching

THEME_DIR="$HOME/.config/chromium/Default/Extensions/japanese-paper-theme"
PREFS_FILE="$HOME/.config/chromium/Default/Preferences"

# Ensure theme directory exists
mkdir -p "$THEME_DIR"

# Copy theme manifest - look in multiple possible locations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
STOW_MANIFEST="$REPO_ROOT/stow/chromium/.config/chromium/Default/Extensions/japanese-paper-theme/manifest.json"

# Try to find manifest in stow directory
if [ ! -f "$STOW_MANIFEST" ] && [ -d "$HOME/fedorarch" ]; then
    STOW_MANIFEST="$HOME/fedorarch/stow/chromium/.config/chromium/Default/Extensions/japanese-paper-theme/manifest.json"
fi

# Create manifest if not found (inline creation)
if [ ! -f "$STOW_MANIFEST" ]; then
    mkdir -p "$(dirname "$STOW_MANIFEST")"
    cat > "$STOW_MANIFEST" << 'MANIFEST_EOF'
{
  "manifest_version": 3,
  "name": "Japanese Paper Theme",
  "version": "1.0",
  "description": "Japanese paper theme with aged paper aesthetic",
  "key": "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA7uQLNpP1/Qv7wNNEmyav6g6jpx91KxQSaxvYSWD2Z0C02KgR+SmYhDf8AdExBlrUNIxSLsqmJ0KUpbUekQ+E1rQCNW8tWuVDSxNfd48eeWmIKVZJpjrpTE7h3qYOLT2bdt42l0RUF6ECzNVW2BCAd511xrPKbqzAphu9JXYYjZqVy6OjPH6YWMGUdgKGltBeQ43iTF1Fqu1Jmz9kR6i3qzgipkWDgfqzQDXhPPzkVgyBHiqIfjDcU5ZC4pzNh3vTZJfXegidAkK2xjWA2PBtVlqu6l2nghyp7Sa+TcBQ5J3afdbmaM26L43mnkMBTZI05aTgZoG8GYzSC6TrD394DQIDAQAB",
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

# Copy to theme directory
if [ -f "$STOW_MANIFEST" ]; then
    if [ ! -f "$THEME_DIR/manifest.json" ] || [ "$STOW_MANIFEST" -nt "$THEME_DIR/manifest.json" ]; then
        cp "$STOW_MANIFEST" "$THEME_DIR/manifest.json"
    fi
fi

# Apply theme to Preferences (create if doesn't exist for fresh installs)
# Create directory if needed
mkdir -p "$(dirname "$PREFS_FILE")"
if [ ! -f "$PREFS_FILE" ]; then
    # Create initial Preferences file for fresh install
    echo '{}' > "$PREFS_FILE"
fi

if [ -f "$PREFS_FILE" ]; then
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
    
    # Merge theme - only update if different
    current_theme = prefs.get("theme", {})
    new_theme = theme_config["theme"]
    
    # Check if theme colors match (comparing key colors)
    theme_needs_update = (
        "theme" not in prefs or
        current_theme.get("color", {}).get("toolbar") != new_theme["color"]["toolbar"] or
        current_theme.get("color", {}).get("toolbar_text") != new_theme["color"]["toolbar_text"]
    )
    
    if theme_needs_update:
        prefs.update(theme_config)
        with open(prefs_file, 'w') as f:
            json.dump(prefs, f, indent=2)
except Exception:
    # If JSON is invalid or file doesn't exist, create new one
    try:
        with open(prefs_file, 'w') as f:
            json.dump(theme_config, f, indent=2)
    except Exception:
        pass
PYTHON_SCRIPT
fi

# Force apply theme to Preferences before launch
if [ -f "$PREFS_FILE" ]; then
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
    
    # Force update theme
    prefs["theme"] = theme_config["theme"]
    
    with open(prefs_file, 'w') as f:
        json.dump(prefs, f, indent=2)
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

