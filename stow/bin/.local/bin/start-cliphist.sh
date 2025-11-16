#!/usr/bin/env bash
# Start cliphist watcher for clipboard history
# This ensures cliphist is always watching the clipboard

# Kill any existing watchers
pkill -f "wl-paste.*cliphist" 2>/dev/null || true

# Wait a bit for processes to die
sleep 0.5

# Start the watcher in the background
# wl-paste --watch will keep running and store clipboard changes
nohup sh -c 'wl-paste --type text --watch cliphist store' >/dev/null 2>&1 &
nohup sh -c 'wl-paste --type image --watch cliphist store' >/dev/null 2>&1 &

echo "Cliphist watcher started"

