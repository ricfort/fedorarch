#!/usr/bin/env bash
set -euo pipefail

# Reset workspaces to their assigned monitors
# This script redistributes workspaces across available monitors

# Get list of connected monitors
if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required but not installed"
    exit 1
fi

MONITORS=($(hyprctl monitors -j | jq -r '.[].name' | sort))
NUM_MONITORS=${#MONITORS[@]}

if [ "$NUM_MONITORS" -eq 0 ]; then
    echo "No monitors detected"
    exit 1
fi

echo "Distributing workspaces across $NUM_MONITORS monitor(s)"

# Distribute workspaces evenly across monitors
# If 2 monitors: 1-5 on first, 6-9 on second
# If 3 monitors: 1-3 on first, 4-6 on second, 7-9 on third
# etc.

WORKSPACES_PER_MONITOR=$((10 / NUM_MONITORS))
WORKSPACE=1

for ((i=0; i<NUM_MONITORS; i++)); do
    MONITOR="${MONITORS[$i]}"
    START_WS=$WORKSPACE
    
    if [ $i -eq $((NUM_MONITORS - 1)) ]; then
        # Last monitor gets remaining workspaces
        END_WS=10
    else
        END_WS=$((START_WS + WORKSPACES_PER_MONITOR - 1))
    fi
    
    echo "Assigning workspaces $START_WS-$END_WS to $MONITOR"
    
    for ws in $(seq "$START_WS" "$END_WS"); do
        hyprctl dispatch focusmonitor "$MONITOR" 2>/dev/null || true
        sleep 0.05
        hyprctl dispatch workspace "$ws" 2>/dev/null || true
        sleep 0.05
    done
    
    WORKSPACE=$((END_WS + 1))
done

echo "Workspace distribution complete"

