#!/usr/bin/env bash
# Wrapper script for bluetuith to ensure PATH is set correctly

export PATH="$HOME/.local/bin:$PATH"
exec alacritty --class bluetuith -e bluetuith

