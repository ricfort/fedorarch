#!/usr/bin/env bash
# Screen recording toggle - start/stop recording

RECORDING_DIR="$HOME/Videos/Recordings"
mkdir -p "$RECORDING_DIR"

RECORDING_PID_FILE="/tmp/wf-recorder.pid"
RECORDING_STATUS_FILE="/tmp/wf-recorder-status.txt"

# Check if recording is in progress
if [ -f "$RECORDING_PID_FILE" ]; then
    PID=$(cat "$RECORDING_PID_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        # Stop recording
        kill "$PID" 2>/dev/null
        rm -f "$RECORDING_PID_FILE" "$RECORDING_STATUS_FILE"
        notify-send "Screen Recording" "Recording stopped" --urgency=normal --expire-time=2000 2>/dev/null &
        exit 0
    else
        # PID file exists but process is dead, clean up
        rm -f "$RECORDING_PID_FILE" "$RECORDING_STATUS_FILE"
    fi
fi

# Start recording
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
FILENAME="$RECORDING_DIR/recording-${TIMESTAMP}.mp4"

# Get the focused monitor using hyprctl
FOCUSED_MONITOR=$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused == true) | .name' | head -1)

# Fallback to first monitor if no focused monitor found
if [ -z "$FOCUSED_MONITOR" ]; then
    FOCUSED_MONITOR=$(hyprctl monitors -j 2>/dev/null | jq -r '.[0].name' | head -1)
fi

# If still no monitor found, record all outputs
if [ -z "$FOCUSED_MONITOR" ]; then
    echo "Warning: Could not detect monitor, recording all outputs"
    FOCUSED_MONITOR=""
fi

# Start wf-recorder in background with focused monitor
if [ -n "$FOCUSED_MONITOR" ]; then
    wf-recorder -o "$FOCUSED_MONITOR" -f "$FILENAME" > "$RECORDING_STATUS_FILE" 2>&1 &
else
    # No monitor specified, record all
    wf-recorder -f "$FILENAME" > "$RECORDING_STATUS_FILE" 2>&1 &
fi
RECORDING_PID=$!

# Save PID
echo "$RECORDING_PID" > "$RECORDING_PID_FILE"

# Wait a moment to check if it started successfully
sleep 0.5

if ps -p "$RECORDING_PID" > /dev/null 2>&1; then
    notify-send "Screen Recording" "Recording started\nPress Super+Shift+R to stop" --urgency=normal --expire-time=3000 2>/dev/null &
else
    rm -f "$RECORDING_PID_FILE" "$RECORDING_STATUS_FILE"
    notify-send "Screen Recording" "Failed to start recording" --urgency=critical --expire-time=2000 2>/dev/null &
    exit 1
fi

