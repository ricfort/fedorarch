#!/usr/bin/env bash
# Start hyprpaper and set wallpapers via hyprctl

# Kill any existing instance
killall hyprpaper 2>/dev/null

# Start hyprpaper in background
hyprpaper &

# Wait for socket to be ready
sleep 2

# Preload wallpaper
hyprctl hyprpaper preload /home/ricfort/Pictures/samurailotus.png

# Set wallpaper for all monitors
hyprctl hyprpaper wallpaper "eDP-1,/home/ricfort/Pictures/samurailotus.png"
hyprctl hyprpaper wallpaper "DP-3,/home/ricfort/Pictures/samurailotus.png"
hyprctl hyprpaper wallpaper "HDMI-A-1,/home/ricfort/Pictures/samurailotus.png"
