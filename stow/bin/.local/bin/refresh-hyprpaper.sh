#!/usr/bin/env bash
set -euo pipefail

# Refresh hyprpaper wallpaper (reloads current wallpaper from config)

# Kill existing hyprpaper
killall hyprpaper 2>/dev/null || true
sleep 0.5

# Restart with current config
"$HOME/.local/bin/start-hyprpaper.sh" &

