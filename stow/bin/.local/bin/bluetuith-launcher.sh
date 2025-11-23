#!/usr/bin/env bash
set -euo pipefail

# Wrapper script for bluetuith to ensure PATH is set correctly

export PATH="$HOME/.local/bin:$PATH"
exec alacritty --class bluetuith -e bluetuith

