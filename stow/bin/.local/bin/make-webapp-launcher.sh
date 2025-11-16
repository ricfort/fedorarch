#!/usr/bin/env bash
# Wrapper for make-webapp to ensure it works from desktop entries
exec alacritty --class make-webapp -e "$HOME/.local/bin/make-webapp"

