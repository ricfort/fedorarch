#!/usr/bin/env bash
set -euo pipefail

# Get battery info
BATTERY_PATH="/sys/class/power_supply"
BATTERY=""

# Find battery
if [ -d "$BATTERY_PATH/BAT0" ]; then
    BATTERY="BAT0"
elif [ -d "$BATTERY_PATH/BAT1" ]; then
    BATTERY="BAT1"
else
    # Try to find any battery
    BATTERY=$(ls "$BATTERY_PATH" | grep -i bat | head -1)
fi

if [ -z "$BATTERY" ] || [ ! -d "$BATTERY_PATH/$BATTERY" ]; then
    echo "󰁹"
    exit 0
fi

CAPACITY=$(cat "$BATTERY_PATH/$BATTERY/capacity" 2>/dev/null || echo "0")
STATUS=$(cat "$BATTERY_PATH/$BATTERY/status" 2>/dev/null || echo "Unknown")

CAPACITY_INT=${CAPACITY%.*}

# Create visual bar (10 segments)
BAR_LENGTH=10
FILLED=$((CAPACITY_INT * BAR_LENGTH / 100))
EMPTY=$((BAR_LENGTH - FILLED))

# Build bar with filled and empty segments
BAR=""
for ((i=0; i<FILLED; i++)); do
    BAR="${BAR}█"
done
for ((i=0; i<EMPTY; i++)); do
    BAR="${BAR}░"
done

# Choose icon based on status
if [ "$STATUS" = "Charging" ]; then
    ICON="󰂄"
elif [ "$CAPACITY_INT" -lt 15 ]; then
    ICON="󰁺"
elif [ "$CAPACITY_INT" -lt 30 ]; then
    ICON="󰁻"
elif [ "$CAPACITY_INT" -lt 50 ]; then
    ICON="󰁼"
elif [ "$CAPACITY_INT" -lt 70 ]; then
    ICON="󰁽"
elif [ "$CAPACITY_INT" -lt 90 ]; then
    ICON="󰁾"
else
    ICON="󰁿"
fi

echo "${ICON} ${BAR} ${CAPACITY_INT}%"














