#!/usr/bin/env bash

# Core Hyprland packages
export HYPRLAND_PACKAGES=(
    "hyprland"
    "hyprpaper"
    "hypridle"
    "hyprpicker"
    "hyprcursor"
    "hyprland-qt-support"
    "hyprland-qtutils"
    "xdg-desktop-portal-hyprland"
)

# Essential applications
export ESSENTIAL_PACKAGES=(
    "waybar"
    "tofi"
    "ghostty"
    "chromium"
    "dunst"
    "thunar"
    "sddm"
    "fastfetch"
    "zsh"
)

# Clipboard and utilities
export UTILITY_PACKAGES=(
    "clipman"
    "cliphist"
    "wl-clip-persist"
    "wl-clipboard"
    "wtype"
    "ydotool"
    "grim"
    "slurp"
    "satty"
    "wf-recorder"
    "jq"
    "playerctl"
    "brightnessctl"
)

# Development tools
export DEV_PACKAGES=(
    "neovim"
    "lazygit"
    "lazydocker"
    "python3-pip"
    "python3-devel"
    "nodejs"
    "npm"
    "gcc"
    "gcc-c++"
    "make"
    "docker"
    "docker-compose"
)

# Fonts
export FONT_PACKAGES=(
    "cascadia-code-fonts"
    "fontawesome-6-free-fonts"
)

# Wayland support
export WAYLAND_PACKAGES=(
    "qt5-qtwayland"
)

# Fingerprint support
export FINGERPRINT_PACKAGES=(
    "fprintd"
    "fprintd-pam"
    "libfprint"
)

# Nerd Fonts (optional, from COPR)
export NERD_FONT_PACKAGES=(
    "cascadia-code-nerd-fonts"
)

# Combine all standard DNF packages
export ALL_PACKAGES=(
    "${HYPRLAND_PACKAGES[@]}"
    "${ESSENTIAL_PACKAGES[@]}"
    "${UTILITY_PACKAGES[@]}"
    "${DEV_PACKAGES[@]}"
    "${FONT_PACKAGES[@]}"
    "${WAYLAND_PACKAGES[@]}"
    "${FINGERPRINT_PACKAGES[@]}"
)

