#!/usr/bin/env bash
set -euo pipefail

# Stop all active Docker containers to free RAM
# Docker daemon stays running - only containers are stopped

# Ensure we have a display for notifications
export DISPLAY="${DISPLAY:-:0}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"

# Function to send notification (non-blocking)
send_notification() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"
    
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$title" "$message" --urgency="$urgency" --expire-time=2000 2>/dev/null &
    fi
}

# Check prerequisites
if ! command -v docker >/dev/null 2>&1; then
    send_notification "Docker" "Docker not found" "critical"
    exit 1
fi

# Check if Docker daemon is accessible
if ! docker info >/dev/null 2>&1; then
    send_notification "Docker" "Docker daemon not running" "critical"
    exit 1
fi

# Get list of running containers
running_containers=$(docker ps -q 2>/dev/null || true)

if [ -z "$running_containers" ]; then
    # No containers running
    send_notification "Docker" "No containers running" "normal"
    exit 0
fi

# Count containers
container_count=$(echo "$running_containers" | wc -l)
send_notification "Docker" "Stopping $container_count container(s)..." "normal"

# Stop all running containers
# shellcheck disable=SC2086
if docker stop $running_containers >/dev/null 2>&1; then
    send_notification "Docker" "Stopped $container_count container(s)" "normal"
else
    send_notification "Docker" "Failed to stop containers" "critical"
    exit 1
fi
