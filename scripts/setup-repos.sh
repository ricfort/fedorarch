#!/usr/bin/env bash
set -euo pipefail

# Source libraries and config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/installers.sh"
source "$SCRIPT_DIR/config/repos.sh"

echo "=== Setting up repositories ==="

ensure_sudo

# RPM Fusion repositories
log_info "Checking RPM Fusion repositories..."
if ! rpm -q rpmfusion-free-release >/dev/null 2>&1; then
    log_info "Enabling RPM Fusion free repository..."
    sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
else
    log_success "RPM Fusion free repository already enabled"
fi

if ! rpm -q rpmfusion-nonfree-release >/dev/null 2>&1; then
    log_info "Enabling RPM Fusion nonfree repository..."
    sudo dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
else
    log_success "RPM Fusion nonfree repository already enabled"
fi

# COPR repositories
log_info "Checking COPR repositories..."
for repo in "${COPR_REPOS[@]}"; do
    enable_copr "$repo"
done

log_info "Refreshing package cache..."
sudo dnf update --refresh -y

log_success "Repository setup complete"

