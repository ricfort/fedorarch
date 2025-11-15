#!/bin/bash
# Wrapper script to start hyprpaper with expanded paths
# This allows using ~ in the config file

CONFIG_FILE="$HOME/.config/hyprpaper/hyprpaper.conf"
TEMP_CONFIG=$(mktemp)

# Expand ~ and $HOME in the config file
sed "s|~/|$HOME/|g; s|\$HOME|$HOME|g" "$CONFIG_FILE" > "$TEMP_CONFIG"

# Start hyprpaper with the expanded config
hyprpaper -c "$TEMP_CONFIG"

# Cleanup on exit
trap "rm -f $TEMP_CONFIG" EXIT
