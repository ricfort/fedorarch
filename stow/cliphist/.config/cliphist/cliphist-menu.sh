#!/usr/bin/env bash
set -euo pipefail

if ! command -v cliphist >/dev/null 2>&1; then
    echo "Error: cliphist is not installed or not in PATH"
    exit 1
fi

if ! command -v tofi >/dev/null 2>&1; then
    echo "Error: tofi is not installed or not in PATH"
    exit 1
fi

if ! command -v wl-copy >/dev/null 2>&1; then
    echo "Error: wl-copy is not installed or not in PATH"
    exit 1
fi

selection=$(cliphist list | tofi --prompt-text="Clipboard (Super+V)" \
    --width=700 --height=600 --font="JetBrainsMono Nerd Font" \
    --background-color="#1e1e2e" --selection-color="#a6e3a1")

if [ -n "$selection" ]; then
    echo "$selection" | cliphist decode | wl-copy
fi
