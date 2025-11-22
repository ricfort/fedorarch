#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "  Fedorarch - Omarchy-style Fedora Setup"
echo "=========================================="
echo ""

# Determine if we're running from a local repo or need to clone
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check for sudo access
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo access."
    echo "You may be prompted for your password."
    echo ""
fi

# Install minimal prerequisites if not already installed (needed before cloning)
echo "=== Installing prerequisites ==="
PREREQ_PACKAGES=("git" "curl" "stow" "dnf-plugins-core")
PREREQ_TO_INSTALL=()

for pkg in "${PREREQ_PACKAGES[@]}"; do
    if ! rpm -q "$pkg" >/dev/null 2>&1; then
        PREREQ_TO_INSTALL+=("$pkg")
    fi
done

if [ ${#PREREQ_TO_INSTALL[@]} -gt 0 ]; then
    echo "Installing prerequisites: ${PREREQ_TO_INSTALL[*]}"
    sudo dnf install -y "${PREREQ_TO_INSTALL[@]}"
else
    echo "All prerequisites already installed"
fi

# Check if we're in a git repo with stow directory
if [ ! -d "$SCRIPT_DIR/.git" ] && [ ! -d "$SCRIPT_DIR/stow" ]; then
    # Running via curl | bash - need to clone the repo
    echo ""
    echo "=== Cloning fedorarch repository ==="
    TARGET="$HOME/fedorarch"
    
    if [ -d "$TARGET" ]; then
        echo "Repository already exists at $TARGET"
        echo "Removing old repository..."
        rm -rf "$TARGET"
    fi
    
    # Try SSH first, fall back to HTTPS
    if git clone "git@github.com:ricfort/fedorarch.git" "$TARGET" 2>/dev/null || \
       git clone "https://github.com/ricfort/fedorarch.git" "$TARGET"; then
        SCRIPT_DIR="$TARGET"
        cd "$SCRIPT_DIR"
    else
        echo "Error: Failed to clone repository"
        exit 1
    fi
else
    cd "$SCRIPT_DIR"
fi

echo ""

# Run modular scripts in order
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

if [ ! -d "$SCRIPTS_DIR" ]; then
    echo "Error: scripts directory not found at $SCRIPTS_DIR"
    exit 1
fi

# Make all scripts executable
chmod +x "$SCRIPTS_DIR"/*.sh

# Run setup scripts
echo "=== Step 1/5: Setting up repositories ==="
"$SCRIPTS_DIR/setup-repos.sh"
echo ""

echo "=== Step 2/5: Installing packages ==="
"$SCRIPTS_DIR/install-packages.sh"
echo ""

echo "=== Step 3/5: Backing up existing configurations ==="
"$SCRIPTS_DIR/backup-configs.sh"
echo ""

echo "=== Step 4/5: Deploying configurations ==="
"$SCRIPTS_DIR/deploy-configs.sh"
echo ""

echo "=== Step 5/5: Post-installation setup ==="
"$SCRIPTS_DIR/post-install.sh"
echo ""

echo "=========================================="
echo "  Bootstrap complete!"
echo "=========================================="
echo ""
echo "Your Fedora system has been configured with:"
echo "  ✓ Hyprland window manager"
echo "  ✓ Tofi launcher (Super+Space, Super+K)"
echo "  ✓ Ghostty terminal"
echo "  ✓ Lazygit and Lazydocker"
echo "  ✓ Chromium for webapps"
echo "  ✓ Fingerprint support"
echo "  ✓ All dotfiles deployed"
echo ""
echo "Next steps:"
echo "  1. Log out and select 'Hyprland' from the display manager"
echo "  2. Or reload Hyprland config: hyprctl reload"
echo "  3. Create webapps: make-webapp 'Name' 'https://url.com'"
echo ""
echo "Key bindings:"
echo "  Super+Space  - Application launcher"
echo "  Super+K      - Show keybinds"
echo "  Super+Return - Terminal"
echo "  Super+G      - LazyGit"
echo "  Super+D      - LazyDocker"
echo ""
