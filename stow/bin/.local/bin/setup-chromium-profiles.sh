#!/usr/bin/env bash
set -euo pipefail

# Setup Chromium profiles: Personal (Default) and Work
# This script ensures both profiles exist and are properly configured

echo "Setting up Chromium profiles..."

# Create Personal profile (Default) if it doesn't exist
PERSONAL_DIR="$HOME/.config/chromium/Default"
if [ ! -d "$PERSONAL_DIR" ] || [ ! -f "$PERSONAL_DIR/Preferences" ]; then
    echo "Creating Personal profile (Default)..."
    # Launch Chromium briefly to create the profile, then close it
    timeout 5 chromium-browser --profile-directory=Default --no-first-run --no-default-browser-check --headless --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage 2>/dev/null || true
    sleep 2
    pkill -f "chromium.*Default" 2>/dev/null || true
    echo "Personal profile created"
else
    echo "Personal profile already exists"
fi

# Create Work profile if it doesn't exist
WORK_DIR="$HOME/.config/chromium/Work"
if [ ! -d "$WORK_DIR" ] || [ ! -f "$WORK_DIR/Preferences" ]; then
    echo "Creating Work profile..."
    # Launch Chromium briefly to create the profile, then close it
    timeout 5 chromium-browser --profile-directory=Work --no-first-run --no-default-browser-check --headless --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage 2>/dev/null || true
    sleep 2
    pkill -f "chromium.*Work" 2>/dev/null || true
    echo "Work profile created"
else
    echo "Work profile already exists"
fi

# Update Local State to set profile names
python3 << 'PYTHON_SCRIPT'
import json
import os

local_state_file = os.path.expanduser("~/.config/chromium/Local State")

try:
    with open(local_state_file, 'r') as f:
        local_state = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    local_state = {}

# Ensure profile structure exists
if "profile" not in local_state:
    local_state["profile"] = {}

if "info_cache" not in local_state["profile"]:
    local_state["profile"]["info_cache"] = {}

# Rename Default profile to "Personal" (if it exists and is currently named "Work")
if "Default" in local_state["profile"]["info_cache"]:
    local_state["profile"]["info_cache"]["Default"]["name"] = "Personal"
    print("Renamed Default profile to 'Personal'")
    
# Set Work profile name (if it exists)
if "Work" in local_state["profile"]["info_cache"]:
    local_state["profile"]["info_cache"]["Work"]["name"] = "Work"
    # Also update any other fields that might affect the display name
    if "user_name" in local_state["profile"]["info_cache"]["Work"]:
        local_state["profile"]["info_cache"]["Work"]["user_name"] = "Work"
    print("Work profile name set to 'Work'")

# Set Default as last used (Personal)
local_state["profile"]["last_used"] = "Default"

with open(local_state_file, 'w') as f:
    json.dump(local_state, f, indent=2)

print("Profile names updated in Local State")
PYTHON_SCRIPT

echo ""
echo "Chromium profiles setup complete!"
echo "  - Personal profile: ~/.config/chromium/Default"
echo "  - Work profile: ~/.config/chromium/Work"
echo ""
echo "Super+B will launch Personal profile"
echo "Use chromium-launcher.sh --profile=Work for Work profile"

