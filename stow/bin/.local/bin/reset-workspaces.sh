#!/usr/bin/env bash
set -euo pipefail

# Reset workspaces to their assigned monitors
# Workspaces 1-5 -> DP-3
# Workspaces 6-9 -> DP-1

# Move workspaces 1-5 to DP-3
for ws in 1 2 3 4 5; do
    hyprctl dispatch focusmonitor DP-3 2>/dev/null || true
    sleep 0.05
    hyprctl dispatch workspace "$ws" 2>/dev/null || true
    sleep 0.05
    # Ensure workspace is on the correct monitor
    hyprctl dispatch focusmonitor DP-3 2>/dev/null || true
    hyprctl dispatch workspace "$ws" 2>/dev/null || true
done

# Move workspaces 6-9 to DP-1
for ws in 6 7 8 9; do
    hyprctl dispatch focusmonitor DP-1 2>/dev/null || true
    sleep 0.05
    hyprctl dispatch workspace "$ws" 2>/dev/null || true
    sleep 0.05
    # Ensure workspace is on the correct monitor
    hyprctl dispatch focusmonitor DP-1 2>/dev/null || true
    hyprctl dispatch workspace "$ws" 2>/dev/null || true
done

