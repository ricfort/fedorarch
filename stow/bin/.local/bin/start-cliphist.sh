#!/usr/bin/env bash
# Start cliphist watcher for clipboard history (Omarchy 3.0 approach)
# This ensures cliphist is always watching the clipboard and primary selection

# Kill any existing watchers
pkill -f "wl-paste.*cliphist" 2>/dev/null || true

# Wait a bit for processes to die
sleep 0.5

# Start cliphist watchers in the background (Omarchy 3.0 style)
# Watch clipboard (regular) - for GUI apps and explicit copies
nohup sh -c 'wl-paste --type text --watch cliphist store' >/dev/null 2>&1 &
nohup sh -c 'wl-paste --type image --watch cliphist store' >/dev/null 2>&1 &

# Also watch primary selection - for terminal selections
nohup sh -c 'wl-paste --primary --type text --watch cliphist store' >/dev/null 2>&1 &

echo "Cliphist watcher started (clipboard + primary)"

