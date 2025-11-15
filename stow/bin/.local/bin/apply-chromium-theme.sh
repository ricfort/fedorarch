#!/usr/bin/env bash
set -euo pipefail

# Apply Japanese Paper Theme to Chromium by modifying Preferences
# This merges theme settings into the existing Preferences file

PREFS_FILE="$HOME/.config/chromium/Default/Preferences"
BACKUP_FILE="${PREFS_FILE}.backup.$(date +%s)"

if [ ! -f "$PREFS_FILE" ]; then
    echo "Error: Chromium Preferences file not found at $PREFS_FILE"
    echo "Please run Chromium at least once to create the profile."
    exit 1
fi

echo "Backing up Preferences to: $BACKUP_FILE"
cp "$PREFS_FILE" "$BACKUP_FILE"

# Create Python script to merge theme
python3 << 'PYTHON_SCRIPT'
import json
import sys
import os

prefs_file = os.path.expanduser("~/.config/chromium/Default/Preferences")
backup_file = f"{prefs_file}.backup"

# Theme configuration
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
    
    # Merge theme into preferences
    prefs.update(theme_config)
    
    with open(prefs_file, 'w') as f:
        json.dump(prefs, f, indent=2)
    
    print("Theme applied successfully!")
    print("Restart Chromium to see the changes.")
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
PYTHON_SCRIPT

