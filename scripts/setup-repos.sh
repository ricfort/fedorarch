#!/usr/bin/env bash
set -euo pipefail

echo "=== Setting up COPR repositories ==="

# Function to check if a COPR repo is already enabled
copr_enabled() {
    local repo="$1"
    dnf copr list enabled 2>/dev/null | grep -q "^$repo" || return 1
}

# RPM Fusion repositories
if ! rpm -q rpmfusion-free-release >/dev/null 2>&1; then
    echo "Enabling RPM Fusion free repository..."
    sudo dnf install -y \
        https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
else
    echo "RPM Fusion free repository already enabled"
fi

if ! rpm -q rpmfusion-nonfree-release >/dev/null 2>&1; then
    echo "Enabling RPM Fusion nonfree repository..."
    sudo dnf install -y \
        https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
else
    echo "RPM Fusion nonfree repository already enabled"
fi

# COPR repositories
COPR_REPOS=(
    "solopasha/hyprland"
    "atim/lazygit"
    "atim/lazydocker"
    "alternateved/tofi"
    "leloubil/wl-clip-persist"
    "aquacash5/nerd-fonts"
)

for repo in "${COPR_REPOS[@]}"; do
    if copr_enabled "$repo"; then
        echo "COPR repository $repo already enabled"
    else
        echo "Enabling COPR repository: $repo"
        sudo dnf copr enable -y "$repo" || echo "Warning: Failed to enable $repo"
    fi
done

echo "Refreshing package cache..."
sudo dnf update --refresh -y

echo "=== Repository setup complete ==="

