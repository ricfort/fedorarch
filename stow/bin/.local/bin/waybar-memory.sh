#!/usr/bin/env bash
set -euo pipefail

# Get memory usage
MEMORY=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
MEMORY_INT=$MEMORY

# Create visual bar (10 segments)
BAR_LENGTH=10
FILLED=$((MEMORY_INT * BAR_LENGTH / 100))
EMPTY=$((BAR_LENGTH - FILLED))

# Build bar with filled and empty segments
BAR=""
for ((i=0; i<FILLED; i++)); do
    BAR="${BAR}█"
done
for ((i=0; i<EMPTY; i++)); do
    BAR="${BAR}░"
done

echo "󰍛 ${BAR} ${MEMORY_INT}%"














