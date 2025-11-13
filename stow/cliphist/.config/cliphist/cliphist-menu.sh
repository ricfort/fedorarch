#!/usr/bin/env bash
cliphist list | tofi --prompt-text="Clipboard (Super+V)" \
    --width=700 --height=600 --font="JetBrainsMono Nerd Font" \
    --background-color="#1e1e2e" --selection-color="#a6e3a1" | \
    cliphist decode | wl-copy
