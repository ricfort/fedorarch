#!/usr/bin/env bash
set -euo pipefail

# Wrapper for make-webapp to ensure it works from desktop entries
exec alacritty --class make-webapp -e "$HOME/.local/bin/make-webapp"

