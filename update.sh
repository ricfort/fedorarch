#!/usr/bin/env bash
set -euo pipefail

echo "=== Updating fedorarch dotfiles ==="

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Pull latest changes
echo "Pulling latest changes from git..."
git pull

# Run deployment script
if [ -f "scripts/deploy-configs.sh" ]; then
    echo "Running deployment script..."
    chmod +x scripts/deploy-configs.sh
    ./scripts/deploy-configs.sh
else
    echo "Error: deploy-configs.sh not found!"
    exit 1
fi

echo "Update complete!"
echo ""
echo "Note: Some changes may require restarting services:"
echo "  - Hyprland: Reload config with 'hyprctl reload' or restart Hyprland"
echo "  - Waybar: Restart waybar (killall waybar; waybar &)"
echo "  - Systemd user services: systemctl --user daemon-reload"
