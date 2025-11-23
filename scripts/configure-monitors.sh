#!/usr/bin/env bash
set -euo pipefail

# Source libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

echo "=== Configure Monitors ==="

MONITOR_CONF="$HOME/.config/hypr/monitors.conf"

if [ ! -f "$MONITOR_CONF" ]; then
    log_warn "$MONITOR_CONF not found, creating from template..."
    mkdir -p "$(dirname "$MONITOR_CONF")"
    echo "# Monitor Config" > "$MONITOR_CONF"
    echo "monitor=,preferred,auto,1" >> "$MONITOR_CONF"
fi

EDITOR="${EDITOR:-nano}"

log_info "Opening monitor configuration with $EDITOR..."
log_info "Tip: Use 'hyprctl monitors' in another terminal to see connected screens."

$EDITOR "$MONITOR_CONF"

log_success "Configuration saved. Reloading Hyprland..."

if pgrep -x "Hyprland" >/dev/null; then
    hyprctl reload
else
    log_warn "Hyprland is not running, changes will apply on next login."
fi














