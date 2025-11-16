#!/usr/bin/env bash
set -euo pipefail

echo "=== Post-installation setup ==="

# Set zsh as default shell if zsh is installed and not already the default
if command -v zsh >/dev/null 2>&1; then
    CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
    ZSH_PATH=$(which zsh)
    
    if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
        echo "Setting zsh as default shell..."
        chsh -s "$ZSH_PATH" || {
            echo "Warning: Could not change default shell. You may need to run: chsh -s $ZSH_PATH"
        }
    else
        echo "zsh is already the default shell"
    fi
else
    echo "zsh is not installed, skipping shell change"
fi

# Enable SDDM display manager
if systemctl is-enabled sddm >/dev/null 2>&1; then
    echo "SDDM already enabled"
else
    echo "Enabling SDDM display manager..."
    sudo systemctl enable sddm --force || echo "Warning: Failed to enable SDDM"
fi

# Enable fingerprint authentication
echo "Setting up fingerprint authentication..."
if sudo authselect list-features | grep -q "with-fingerprint"; then
    if sudo authselect current | grep -q "with-fingerprint"; then
        echo "Fingerprint authentication already enabled"
    else
        echo "Enabling fingerprint authentication..."
        sudo authselect enable-feature with-fingerprint || echo "Warning: Failed to enable fingerprint feature"
    fi
else
    echo "Warning: Fingerprint feature not available in authselect"
fi

# Setup cliphist systemd service
echo "Setting up cliphist service..."
mkdir -p ~/.config/systemd/user

if [ -f ~/.config/systemd/user/cliphist.service ]; then
    echo "Cliphist service already configured"
else
    cat > ~/.config/systemd/user/cliphist.service << 'EOF'
[Unit]
Description=Cliphist

[Service]
ExecStart=/usr/bin/cliphist store
Restart=always

[Install]
WantedBy=default.target
EOF
    echo "Cliphist service created"
fi

# Enable and start cliphist service
if systemctl --user is-enabled cliphist.service >/dev/null 2>&1; then
    echo "Cliphist service already enabled"
else
    echo "Enabling cliphist service..."
    systemctl --user enable cliphist.service || echo "Warning: Failed to enable cliphist service"
fi

if systemctl --user is-active cliphist.service >/dev/null 2>&1; then
    echo "Cliphist service already running"
else
    echo "Starting cliphist service..."
    systemctl --user start cliphist.service || echo "Warning: Failed to start cliphist service"
fi

# Reload systemd user daemon
systemctl --user daemon-reload || true

# Setup Docker
echo "Setting up Docker..."
if command -v docker >/dev/null 2>&1; then
    # Add user to docker group if not already added
    if ! groups | grep -q docker; then
        echo "Adding user to docker group..."
        sudo usermod -aG docker "$USER" || echo "Warning: Failed to add user to docker group"
        echo "Note: You may need to log out and back in for docker group changes to take effect"
    else
        echo "User is already in docker group"
    fi
    
    # Enable and start Docker service (runs on boot, stays alive)
    # Super+Shift+D will stop containers, not the daemon
    if systemctl is-enabled docker >/dev/null 2>&1; then
        echo "Docker service already enabled"
    else
        echo "Enabling Docker service..."
        sudo systemctl enable docker || echo "Warning: Failed to enable Docker service"
    fi
    
    # Start Docker service if not already running
    if systemctl is-active --quiet docker 2>/dev/null; then
        echo "Docker service already running"
    else
        echo "Starting Docker service..."
        sudo systemctl start docker || echo "Warning: Failed to start Docker service"
    fi
else
    echo "Docker is not installed, skipping Docker setup"
fi

# Setup Chromium profiles
echo "Setting up Chromium profiles..."
if command -v chromium-browser >/dev/null 2>&1 || command -v chromium >/dev/null 2>&1; then
    if [ -f "$HOME/.local/bin/setup-chromium-profiles.sh" ]; then
        echo "Configuring Chromium profiles (Personal and Work)..."
        "$HOME/.local/bin/setup-chromium-profiles.sh" || echo "Warning: Failed to set up Chromium profiles"
    else
        echo "Warning: setup-chromium-profiles.sh not found"
    fi
else
    echo "Chromium is not installed, skipping Chromium profile setup"
fi

# Setup shell (bash compatibility, even though we use zsh as default)
echo "Setting up shell configuration..."
if [ -f "$HOME/.local/bin/setup-shell.sh" ]; then
    echo "Configuring bash shell (for compatibility)..."
    "$HOME/.local/bin/setup-shell.sh" || echo "Warning: Failed to set up shell configuration"
else
    echo "Warning: setup-shell.sh not found"
fi

# Prepare wallpapers (optional - only if source image exists)
echo "Checking for wallpaper preparation..."
if [ -f "$HOME/.local/bin/prepare-wallpaper.sh" ]; then
    if [ -f "$HOME/Pictures/samurailotus.png" ]; then
        echo "Preparing wallpapers from source image..."
        "$HOME/.local/bin/prepare-wallpaper.sh" || echo "Warning: Failed to prepare wallpapers"
    else
        echo "Wallpaper source image not found, skipping wallpaper preparation"
        echo "  (Place samurailotus.png in ~/Pictures/ to auto-generate wallpapers)"
    fi
else
    echo "Warning: prepare-wallpaper.sh not found"
fi

# Ensure fprintd service is running
echo "Checking fprintd service..."
if systemctl is-active fprintd >/dev/null 2>&1; then
    echo "fprintd service is running"
else
    echo "Starting fprintd service..."
    sudo systemctl start fprintd || echo "Warning: Failed to start fprintd service"
    sudo systemctl enable fprintd || echo "Warning: Failed to enable fprintd service"
fi

# Fingerprint enrollment prompt (optional, can be done later)
echo ""
echo "=== Fingerprint Enrollment (Optional) ==="

# Check if fprintd is installed
if ! rpm -q fprintd >/dev/null 2>&1; then
    echo "⚠ fprintd package is not installed."
    echo "  Installing fprintd and fprintd-clients..."
    sudo dnf install -y fprintd fprintd-clients libfprint || {
        echo "  Failed to install fprintd. You can install it later with:"
        echo "    sudo dnf install fprintd fprintd-clients libfprint"
    }
fi

# Check for fprintd-enroll command (try multiple locations)
FPRINTD_ENROLL=""
if command -v fprintd-enroll >/dev/null 2>&1; then
    FPRINTD_ENROLL="fprintd-enroll"
elif [ -f /usr/bin/fprintd-enroll ]; then
    FPRINTD_ENROLL="/usr/bin/fprintd-enroll"
fi

if [ -n "$FPRINTD_ENROLL" ]; then
    echo "Fingerprint enrollment can be done now or later."
    echo ""
    echo "Would you like to enroll your fingerprint now? (y/n)"
    read -r enroll_choice < /dev/tty || enroll_choice="n"
    
    if [[ "$enroll_choice" =~ ^[Yy]$ ]]; then
        echo ""
        echo "Starting fingerprint enrollment..."
        echo "Follow the on-screen instructions to enroll your fingerprint."
        echo ""
        echo "Note: If you get 'not authorized' error, you can:"
        echo "  1. Skip for now and enroll later with: sudo fprintd-enroll"
        echo "  2. Or use GUI: Open Settings > Users > Fingerprint Login"
        echo ""
        
        # Try regular enrollment first
        ENROLL_OUTPUT=$($FPRINTD_ENROLL 2>&1) || ENROLL_FAILED=1
        if [ -z "${ENROLL_FAILED:-}" ]; then
            echo "✓ Fingerprint enrollment completed successfully!"
        else
            if echo "$ENROLL_OUTPUT" | grep -q "not authorized\|Permission denied\|polkit"; then
                echo ""
                echo "Authorization error detected. Trying with sudo..."
                echo "You may be prompted for your password."
                if sudo $FPRINTD_ENROLL 2>&1; then
                    echo "✓ Fingerprint enrollment completed successfully (with sudo)!"
                else
                    echo ""
                    echo "⚠ Fingerprint enrollment failed. This is okay - you can do it later."
                    echo ""
                    echo "To enroll later, run one of these:"
                    echo "  sudo $FPRINTD_ENROLL"
                    echo "  Or use GUI: Settings > Users > Fingerprint Login"
                fi
            else
                echo "⚠ Fingerprint enrollment failed or was cancelled."
                echo "You can enroll later by running: sudo $FPRINTD_ENROLL"
            fi
        fi
    else
        echo "Skipping fingerprint enrollment for now."
        echo ""
        echo "To enroll later, run:"
        if [ -n "$FPRINTD_ENROLL" ]; then
            echo "  sudo $FPRINTD_ENROLL"
        else
            echo "  sudo fprintd-enroll"
        fi
        echo ""
        echo "Or use the GUI:"
        echo "  Settings > Users > Fingerprint Login"
    fi
else
    echo "⚠ fprintd-enroll command not found."
    echo "  fprintd package may not be installed or command is in a different location."
    echo ""
    echo "To install fprintd:"
    echo "  sudo dnf install fprintd libfprint"
    echo ""
    echo "Then enroll with:"
    echo "  sudo fprintd-enroll"
    echo ""
    echo "Or use the GUI: Settings > Users > Fingerprint Login"
fi

echo ""
echo "=== Post-installation setup complete ==="
echo ""
echo "Next steps:"
echo "1. Log out and select Hyprland from the display manager"
echo "2. Or if already in Hyprland, reload config: hyprctl reload"
echo "3. Enroll fingerprint later if skipped: fprintd-enroll"

