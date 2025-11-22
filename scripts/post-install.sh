#!/usr/bin/env bash
set -euo pipefail

# Source libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

echo "=== Post-installation setup ==="

ensure_sudo

# 1. Default Shell (zsh)
if check_command zsh; then
    CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
    ZSH_PATH=$(which zsh)
    
    if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
        log_info "Setting zsh as default shell..."
        sudo chsh -s "$ZSH_PATH" "$USER" || log_warn "Could not change shell. Run: chsh -s $ZSH_PATH"
    else
        log_info "zsh is already default shell"
    fi
fi

# 2. Services
enable_service "sddm"

# Fingerprint
log_info "Setting up fingerprint authentication..."
if sudo authselect list-features | grep -q "with-fingerprint"; then
    if sudo authselect current | grep -q "with-fingerprint"; then
        log_info "Fingerprint auth already enabled"
    else
        sudo authselect enable-feature with-fingerprint || log_warn "Failed to enable fingerprint feature"
    fi
fi
start_service "fprintd"
enable_service "fprintd"

# Cliphist (User Service)
log_info "Setting up cliphist service..."
mkdir -p ~/.config/systemd/user
if [ ! -f ~/.config/systemd/user/cliphist.service ]; then
    cat > ~/.config/systemd/user/cliphist.service << 'EOF'
[Unit]
Description=Cliphist

[Service]
ExecStart=/usr/bin/cliphist store
Restart=always

[Install]
WantedBy=default.target
EOF
    log_success "Cliphist service created"
fi

enable_user_service "cliphist.service"
start_user_service "cliphist.service"
systemctl --user daemon-reload || true

# Docker
if check_command docker; then
    if ! groups | grep -q docker; then
        log_info "Adding user to docker group..."
        sudo usermod -aG docker "$USER"
    fi
    enable_service "docker"
    start_service "docker"
fi

# 3. Run Local Setup Scripts (deployed by stow)
run_local_script() {
    local script="$1"
    local name="$2"
    if [ -f "$HOME/.local/bin/$script" ]; then
        log_info "Running $name..."
        "$HOME/.local/bin/$script" || log_warn "Failed to run $script"
    else
        log_warn "$script not found (maybe skipped stow?)"
    fi
}

run_local_script "setup-chromium-profiles.sh" "Chromium profiles setup"
run_local_script "setup-shell.sh" "Shell configuration"
run_local_script "setup-gtk-theme.sh" "GTK theme setup"

# Wallpaper
if [ -f "$HOME/Pictures/samurailotus.png" ]; then
    run_local_script "prepare-wallpaper.sh" "Wallpaper preparation"
else
    log_info "Wallpaper source not found, skipping preparation"
fi

# 4. Fingerprint Enrollment
# (kept simplified/interactive if needed, or just point user to it)
if check_command fprintd-enroll; then
    log_info "To enroll fingerprint run: sudo fprintd-enroll"
    # We skip interactive enrollment in automated scripts usually, unless requested.
    # The original script asked interactively. I'll leave a note.
fi

log_success "Post-installation setup complete"
