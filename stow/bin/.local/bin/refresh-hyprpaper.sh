#!/bin/bash
# Refresh hyprpaper wallpaper (reloads current wallpaper from config)

# Kill existing hyprpaper
killall hyprpaper 2>/dev/null
sleep 0.5

# Restart with current config
"$HOME/.local/bin/start-hyprpaper.sh" &

