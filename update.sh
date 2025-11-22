#!/usr/bin/env bash
set -euo pipefail

echo "Updating fedorarch dotfiles..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Pull latest changes
echo "Pulling latest changes from git..."
git pull

# Re-stow all directories
echo "Re-stowing dotfiles..."
if [ -d stow ]; then
    # First, clean up any broken symlinks
    echo "Cleaning up broken symlinks..."
    find ~/.config -type l ! -exec test -e {} \; -delete 2>/dev/null || true
    find ~/.local/bin -type l ! -exec test -e {} \; -delete 2>/dev/null || true
    find ~/.local/share -type l ! -exec test -e {} \; -delete 2>/dev/null || true
    
    for dir in stow/*/; do
        # Check if glob matched any directories
        [ -d "$dir" ] || break
        package_name=$(basename "$dir")
        echo "Stowing $package_name..."
        
        # Unstow first to avoid conflicts
        stow -D -d stow -t ~ "$package_name" 2>/dev/null || true
        
        # Ensure target directories exist
        case "$package_name" in
            ghostty)
                mkdir -p ~/.config/ghostty
                ;;
            hyprland|hyprland-keys)
                mkdir -p ~/.config/hypr
                ;;
            waybar)
                mkdir -p ~/.config/waybar
                ;;
            nvim)
                mkdir -p ~/.config/nvim
                ;;
            cliphist)
                mkdir -p ~/.config/cliphist
                ;;
            tofi)
                mkdir -p ~/.config/tofi
                ;;
            mise)
                mkdir -p ~/.config/mise
                ;;
            bin)
                mkdir -p ~/.local/bin
                ;;
        esac
        
        # Stow with error handling
        if ! stow -d stow -t ~ "$package_name" 2>&1 | tee /tmp/stow_output.log; then
            if grep -q "conflicts" /tmp/stow_output.log; then
                echo "Warning: Conflicts detected for $package_name"
                echo "  Run manually to resolve: stow -d stow -t ~ $package_name"
            else
                echo "Warning: Failed to stow $package_name"
            fi
        fi
    done
    rm -f /tmp/stow_output.log
else
    echo "Error: stow directory not found!"
    exit 1
fi

# Make sure scripts are executable
if [ -d ~/.local/bin ]; then
    echo "Making scripts executable..."
    chmod +x ~/.local/bin/* 2>/dev/null || true
fi

echo "Update complete!"
echo ""
echo "Note: Some changes may require restarting services:"
echo "  - Hyprland: Reload config with 'hyprctl reload' or restart Hyprland"
echo "  - Waybar: Restart waybar (killall waybar; waybar &)"
echo "  - Systemd user services: systemctl --user daemon-reload"

