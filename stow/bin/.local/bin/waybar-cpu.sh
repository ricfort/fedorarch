#!/usr/bin/env bash
set -euo pipefail

# Get CPU usage
CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
CPU_INT=${CPU%.*}

# Create visual bar (10 segments)
BAR_LENGTH=10
FILLED=$((CPU_INT * BAR_LENGTH / 100))
EMPTY=$((BAR_LENGTH - FILLED))

# Build bar with filled and empty segments
BAR=""
for ((i=0; i<FILLED; i++)); do
    BAR="${BAR}█"
done
for ((i=0; i<EMPTY; i++)); do
    BAR="${BAR}░"
done

echo "󰻠 ${BAR} ${CPU_INT}%"














