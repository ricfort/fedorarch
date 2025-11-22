#!/usr/bin/env bash
set -euo pipefail

# Source libraries and config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/installers.sh"
source "$SCRIPT_DIR/config/packages.sh"

echo "=== Installing packages ==="

ensure_sudo

# 1. Install main packages (excluding qt6-qtwayland to avoid conflicts)
log_info "Installing system packages..."
install_dnf_opts "--exclude=qt6-qtwayland" "${ALL_PACKAGES[@]}"

# 2. Handle Qt6 conflicts and Hyprland Qt support
log_info "Checking Qt6 compatibility..."
if is_dnf_installed "qt6-qtwayland"; then
    log_warn "qt6-qtwayland is installed. Checking for conflicts..."
    if ! sudo dnf update -y qt6-qtbase 2>/dev/null; then
        log_warn "qt6-qtwayland conflicts detected. Consider removing it if issues arise."
        log_warn "Command: sudo dnf remove qt6-qtwayland qt6-qtwayland-adwaita-decoration"
    fi
else
    log_info "qt6-qtwayland not installed (good for compatibility)"
fi

# Install specific Hyprland Qt tools that might conflict
install_dnf "hyprland-qt-support" || log_warn "Failed to install hyprland-qt-support (likely Qt6 conflict)"
install_dnf "hyprland-qtutils" || log_warn "Failed to install hyprland-qtutils (likely Qt6 conflict)"

# 3. NVIDIA Drivers (Optional)
if ! is_dnf_installed "akmod-nvidia"; then
    log_info "Attempting to install NVIDIA drivers (optional)..."
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda 2>/dev/null || \
        log_info "NVIDIA drivers not installed (may not be needed)"
fi

# 4. External Tools
log_info "=== Installing development tools ==="

# Ensure PATH
export PATH="$HOME/.local/bin:$PATH"

# Mise & uv
install_mise
install_uv

# Spotify (Flatpak)
log_info "Installing Spotify..."
install_flatpak "flathub" "com.spotify.Client"

# Bluetuith
BLUETUITH_VER="v0.1.8"
BLUETUITH_URL="https://github.com/bluetuith-org/bluetuith/releases/download/${BLUETUITH_VER}/bluetuith_${BLUETUITH_VER#v}_Linux_x86_64.tar.gz"
install_from_url "bluetuith" "$BLUETUITH_URL" "bluetuith"

# Hyprmon
HYPRMON_VER="v0.0.12"
HYPRMON_URL="https://github.com/erans/hyprmon/releases/download/${HYPRMON_VER}/hyprmon-linux-amd64.tar.gz"
# Binary in archive is hyprmon-linux-amd64, we want hyprmon
install_from_url "hyprmon" "$HYPRMON_URL" "hyprmon" "$HOME/.local/bin" "hyprmon-linux-amd64"

# 5. Setup Shell Integration
log_info "Setting up shell integration..."

if check_command mise; then
    eval "$(mise activate bash)" || true
    if [ -f ~/.bashrc ] && ! grep -q 'eval "$(mise activate bash)"' ~/.bashrc; then
        echo 'eval "$(mise activate bash)"' >> ~/.bashrc
    fi
    # Install default languages
    mise install python@latest nodejs@latest 2>/dev/null || true
    mise use python@latest nodejs@latest 2>/dev/null || true
fi

if check_command uv; then
    uv tool install ruff 2>/dev/null || true
    uv tool install black 2>/dev/null || true
    uv tool install debugpy 2>/dev/null || true
fi

# Ensure PATH in bashrc
if [ -f ~/.bashrc ] && ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

log_success "Package installation complete"
