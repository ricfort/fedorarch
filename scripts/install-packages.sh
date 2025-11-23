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
    mise install python@latest nodejs@latest go@latest 2>/dev/null || true
    mise use python@latest nodejs@latest go@latest 2>/dev/null || true
fi

# Install Gemini CLI via npm (if node is available)
if check_command npm; then
    log_info "Installing Gemini CLI..."
    if ! check_command gemini; then
        # Install directly to ~/.local to avoid permission issues without changing global config
        # This puts the binary in ~/.local/bin which is already in PATH
        mkdir -p "$HOME/.local"
        if npm install -g --prefix "$HOME/.local" @google/gemini-cli; then
            log_success "Gemini CLI installed to ~/.local/bin"
        else
            log_warn "Failed to install Gemini CLI to ~/.local"
            log_info "Attempting global install with sudo..."
            sudo npm install -g @google/gemini-cli || log_warn "Failed to install Gemini CLI"
        fi
    else
        log_success "Gemini CLI already installed"
    fi

    if check_command gemini; then
        log_info "Installing/updating gemini extensions..."

        # Function to install a gemini extension if not already installed
        install_gemini_extension() {
            local extension_name=$1
            local extension_url=$2
            
            # Use gemini extensions list and grep to check if the extension is installed
            if gemini extensions list | grep -q "$extension_name"; then
                log_success "Gemini extension '$extension_name' is already installed."
            else
                log_info "Installing gemini extension '$extension_name'..."
                if gemini extensions install "$extension_url"; then
                    log_success "Successfully installed '$extension_name'."
                else
                    log_warn "Failed to install gemini extension '$extension_name'."
                fi
            fi
        }

        install_gemini_extension "genai-toolbox" "https://github.com/googleapis/genai-toolbox"
        install_gemini_extension "github-mcp-server" "https://github.com/github/github-mcp-server"
        install_gemini_extension "slash-criticalthink" "https://github.com/abagames/slash-criticalthink"
    else
        log_warn "gemini not found, skipping gemini extensions installation"
    fi

else
    log_warn "npm not found, skipping Gemini CLI installation"
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
