#!/usr/bin/env bash
set -euo pipefail

echo "=== Installing packages ==="

# Function to check if a package is installed
package_installed() {
    rpm -q "$1" >/dev/null 2>&1
}

# Core Hyprland packages
HYPRLAND_PACKAGES=(
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
ESSENTIAL_PACKAGES=(
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
UTILITY_PACKAGES=(
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
)

# Development tools
DEV_PACKAGES=(
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
FONT_PACKAGES=(
    "cascadia-code-fonts"
    "fontawesome-6-free-fonts"
)

# Wayland support (qt5 required, qt6 optional due to potential conflicts)
WAYLAND_PACKAGES=(
    "qt5-qtwayland"
)

# Fingerprint support
FINGERPRINT_PACKAGES=(
    "fprintd"
    "fprintd-pam"
    "libfprint"
)

# Nerd Fonts (optional, from COPR)
NERD_FONT_PACKAGES=(
    "cascadia-code-nerd-fonts"
)

# Combine all packages
ALL_PACKAGES=(
    "${HYPRLAND_PACKAGES[@]}"
    "${ESSENTIAL_PACKAGES[@]}"
    "${UTILITY_PACKAGES[@]}"
    "${DEV_PACKAGES[@]}"
    "${FONT_PACKAGES[@]}"
    "${WAYLAND_PACKAGES[@]}"
    "${FINGERPRINT_PACKAGES[@]}"
)

# Install packages that aren't already installed
PACKAGES_TO_INSTALL=()
for pkg in "${ALL_PACKAGES[@]}"; do
    if package_installed "$pkg"; then
        echo "Package $pkg already installed"
    else
        PACKAGES_TO_INSTALL+=("$pkg")
    fi
done

if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    echo "Installing packages: ${PACKAGES_TO_INSTALL[*]}"
    # Exclude qt6-qtwayland to avoid dependency conflicts
    # It's optional and qt5-qtwayland is sufficient
    sudo dnf install -y --exclude=qt6-qtwayland "${PACKAGES_TO_INSTALL[@]}" || {
        echo "Warning: Some packages failed to install"
        echo "  This may be due to qt6-qtwayland conflicts"
        echo "  Continuing with installation..."
    }
else
    echo "All required packages already installed"
fi

# Handle qt6-qtwayland conflicts
# qt6-qtwayland is optional - qt5-qtwayland is sufficient for most Qt apps
if package_installed "qt6-qtwayland"; then
    echo "qt6-qtwayland is installed - checking for version conflicts..."
    # Try to update qt6-qtbase to resolve conflicts
    if sudo dnf update -y qt6-qtbase 2>/dev/null; then
        echo "Updated qt6-qtbase to resolve conflicts"
    else
        echo "Warning: qt6-qtwayland version conflicts detected"
        echo "  qt5-qtwayland is sufficient for most Qt applications"
        echo "  Consider removing qt6-qtwayland if you encounter issues:"
        echo "  sudo dnf remove qt6-qtwayland qt6-qtwayland-adwaita-decoration"
    fi
else
    echo "Skipping qt6-qtwayland installation (optional package)"
    echo "  qt5-qtwayland is sufficient for most Qt applications on Wayland"
    echo "  Qt6 applications will still work using qt5-qtwayland"
fi

# Ensure hyprland-qt-support and hyprland-qtutils are installed (required for Qt dialogs)
# Note: These require Qt 6.9, which may conflict with qt6-qtwayland (Qt 6.10)
if ! package_installed "hyprland-qt-support"; then
    echo "Installing hyprland-qt-support..."
    if sudo dnf install -y hyprland-qt-support 2>/dev/null; then
        echo "hyprland-qt-support installed successfully"
    else
        echo "Warning: Failed to install hyprland-qt-support"
        echo "  This is due to Qt6 version conflict:"
        echo "  - hyprland-qt-support requires Qt 6.9"
        echo "  - qt6-qtwayland requires Qt 6.10"
        echo "  Solution: Remove qt6-qtwayland (qt5-qtwayland is sufficient):"
        echo "    sudo dnf remove qt6-qtwayland qt6-qtwayland-adwaita-decoration"
        echo "    Then re-run this script"
    fi
else
    echo "hyprland-qt-support already installed"
fi

if ! package_installed "hyprland-qtutils"; then
    echo "Installing hyprland-qtutils..."
    if sudo dnf install -y hyprland-qtutils 2>/dev/null; then
        echo "hyprland-qtutils installed successfully"
    else
        echo "Warning: Failed to install hyprland-qtutils"
        if package_installed "qt6-qtwayland"; then
            echo "  Qt6 version conflict detected"
            echo "  hyprland-qtutils requires Qt 6.9, but qt6-qtwayland requires Qt 6.10"
            echo "  Solution: Remove qt6-qtwayland (qt5-qtwayland is sufficient):"
            echo "    sudo dnf remove qt6-qtwayland qt6-qtwayland-adwaita-decoration"
            echo "    Then re-run this script"
        else
            echo "  Make sure the solopasha/hyprland COPR repository is enabled"
        fi
    fi
else
    echo "hyprland-qtutils already installed"
fi

# Install Nerd Fonts (optional, may fail if COPR not available)
if ! package_installed "cascadia-code-nerd-fonts"; then
    echo "Installing Cascadia Code Nerd Fonts..."
    if sudo dnf install -y cascadia-code-nerd-fonts 2>/dev/null; then
        echo "Cascadia Code Nerd Fonts installed successfully"
    else
        echo "Warning: Failed to install Cascadia Code Nerd Fonts (COPR may not be available)"
        echo "You can install manually: sudo dnf install cascadia-code-nerd-fonts"
    fi
else
    echo "Cascadia Code Nerd Fonts already installed"
fi

# Optional: NVIDIA drivers (will fail gracefully if not needed)
if ! package_installed "akmod-nvidia"; then
    echo "Attempting to install NVIDIA drivers (optional)..."
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda 2>/dev/null || \
        echo "NVIDIA drivers not installed (may not be needed or not available)"
fi

# Install development tools via external installers
echo "=== Installing development tools ==="

# Ensure PATH includes ~/.local/bin before checking
export PATH="$HOME/.local/bin:$PATH"

# Mise (version manager)
if ! command -v mise >/dev/null 2>&1 && [ ! -f ~/.local/bin/mise ]; then
    echo "Installing mise..."
    curl -fsSL https://mise.jdx.dev/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "mise already installed"
fi

# uv (Python package manager)
if ! command -v uv >/dev/null 2>&1 && [ ! -f ~/.local/bin/uv ]; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "uv already installed"
fi

# Spotify (via Flatpak)
if ! flatpak list | grep -q "com.spotify.Client" 2>/dev/null; then
    echo "Installing Spotify..."
    if command -v flatpak >/dev/null 2>&1; then
        if ! flatpak remote-list | grep -q "flathub" 2>/dev/null; then
            echo "Adding Flathub repository..."
            flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        fi
        flatpak install -y flathub com.spotify.Client 2>/dev/null || {
            echo "Warning: Failed to install Spotify via Flatpak"
            echo "  Make sure Flatpak is installed: sudo dnf install flatpak"
        }
    else
        echo "Installing Flatpak first..."
        sudo dnf install -y flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install -y flathub com.spotify.Client 2>/dev/null || {
            echo "Warning: Failed to install Spotify via Flatpak"
        }
    fi
else
    echo "Spotify already installed"
fi

# bluetuith (Bluetooth TUI - not in Fedora repos, install from GitHub)
if ! command -v bluetuith >/dev/null 2>&1 && [ ! -f ~/.local/bin/bluetuith ]; then
    echo "Installing bluetuith..."
    BLUETUITH_VERSION="v0.1.8"
    BLUETUITH_URL="https://github.com/bluetuith-org/bluetuith/releases/download/${BLUETUITH_VERSION}/bluetuith_${BLUETUITH_VERSION#v}_Linux_x86_64.tar.gz"
    mkdir -p /tmp/bluetuith-install
    cd /tmp/bluetuith-install
    if curl -L -o bluetuith.tar.gz "$BLUETUITH_URL" 2>/dev/null; then
        tar -xzf bluetuith.tar.gz
        mkdir -p ~/.local/bin
        mv bluetuith ~/.local/bin/bluetuith
        chmod +x ~/.local/bin/bluetuith
        rm -rf /tmp/bluetuith-install
        export PATH="$HOME/.local/bin:$PATH"
        echo "bluetuith installed successfully"
    else
        echo "Warning: Failed to download bluetuith from GitHub"
        rm -rf /tmp/bluetuith-install
    fi
else
    echo "bluetuith already installed"
fi


# hyprmon (Monitor TUI - not in Fedora repos, install from GitHub)
export PATH="$HOME/.local/bin:$PATH"
if ! command -v hyprmon >/dev/null 2>&1 && [ ! -f ~/.local/bin/hyprmon ]; then
    echo "Installing hyprmon..."
    HYPRMON_VERSION="v0.0.12"
    HYPRMON_URL="https://github.com/erans/hyprmon/releases/download/${HYPRMON_VERSION}/hyprmon-linux-amd64.tar.gz"
    mkdir -p /tmp/hyprmon-install
    cd /tmp/hyprmon-install
    if curl -L -o hyprmon.tar.gz "$HYPRMON_URL" 2>/dev/null; then
        if file hyprmon.tar.gz | grep -q "gzip"; then
            tar -xzf hyprmon.tar.gz
        else
            tar -xf hyprmon.tar.gz
        fi
        mkdir -p ~/.local/bin
        if [ -f hyprmon ]; then
            mv hyprmon ~/.local/bin/hyprmon
        elif [ -f hyprmon-linux-amd64 ]; then
            mv hyprmon-linux-amd64 ~/.local/bin/hyprmon
        fi
        chmod +x ~/.local/bin/hyprmon
        rm -rf /tmp/hyprmon-install
        export PATH="$HOME/.local/bin:$PATH"
        echo "hyprmon installed successfully"
    else
        echo "Warning: Failed to download hyprmon from GitHub"
        rm -rf /tmp/hyprmon-install
    fi
else
    echo "hyprmon already installed"
fi

# Setup mise and uv tools if available
export PATH="$HOME/.local/bin:$PATH"

if command -v mise >/dev/null 2>&1; then
    echo "Setting up mise..."
    eval "$(mise activate bash)" || true
    if [ -f ~/.bashrc ]; then
        if ! grep -q 'eval "$(mise activate bash)"' ~/.bashrc; then
            echo 'eval "$(mise activate bash)"' >> ~/.bashrc
        fi
    fi
    mise install python@latest nodejs@latest 2>/dev/null || true
    mise use python@latest nodejs@latest 2>/dev/null || true
fi

if command -v uv >/dev/null 2>&1; then
    echo "Installing uv tools..."
    uv tool install ruff 2>/dev/null || true
    uv tool install black 2>/dev/null || true
    uv tool install debugpy 2>/dev/null || true
fi

# Ensure PATH is in bashrc
if [ -f ~/.bashrc ]; then
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
fi

echo "=== Package installation complete ==="

