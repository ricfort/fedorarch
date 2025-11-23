#!/usr/bin/env bash
set -euo pipefail

# Source libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

# Check arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <theme_name>"
    echo "Available themes:"
    ls -1 "$SCRIPT_DIR/../themes"
    exit 1
fi

THEME_NAME="$1"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
THEMES_DIR="$REPO_ROOT/themes"
THEME_PATH="$THEMES_DIR/$THEME_NAME"

if [ ! -d "$THEME_PATH" ]; then
    log_error "Theme '$THEME_NAME' not found in $THEMES_DIR"
    exit 1
fi

log_info "Switching to theme: $THEME_NAME"

# Helper to link theme files
link_theme_file() {
    local source_file="$1"
    local target_link="$2"
    
    if [ -f "$source_file" ]; then
        mkdir -p "$(dirname "$target_link")"
        ln -sf "$source_file" "$target_link"
        log_success "Linked $(basename "$target_link")"
    else
        log_warn "Theme file not found: $(basename "$source_file")"
    fi
}

# 1. Hyprland
link_theme_file "$THEME_PATH/hyprland.conf" "$HOME/.config/hypr/theme.conf"

# 2. Waybar
link_theme_file "$THEME_PATH/waybar.css" "$HOME/.config/waybar/theme.css"

# 3. Ghostty
link_theme_file "$THEME_PATH/ghostty.conf" "$HOME/.config/ghostty/theme"

# 4. Tofi
link_theme_file "$THEME_PATH/tofi.conf" "$HOME/.config/tofi/theme"

# 5. Dunst
link_theme_file "$THEME_PATH/dunst.conf" "$HOME/.config/dunst/theme"

# 6. Wallpaper (using hyprpaper via IPC if running)
WALLPAPER_IMG="$THEME_PATH/wallpaper.jpg"
if [ ! -f "$WALLPAPER_IMG" ]; then
    # Fallback to png
    WALLPAPER_IMG="$THEME_PATH/wallpaper.png"
fi

if [ -f "$WALLPAPER_IMG" ]; then
    # Update symlink for persistence
    ln -sf "$WALLPAPER_IMG" "$HOME/.config/hypr/current_wallpaper"
    
    # If hyprpaper is running, reload it
    if pgrep -x "hyprpaper" >/dev/null; then
        log_info "Reloading wallpaper..."
        # Unload all wallpapers
        hyprctl hyprpaper unload all >/dev/null 2>&1 || true
        # Preload new wallpaper
        hyprctl hyprpaper preload "$WALLPAPER_IMG" >/dev/null 2>&1 || true
        # Set wallpaper for all monitors
        for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
            hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER_IMG" >/dev/null 2>&1 || true
        done
    fi
else
    log_warn "No wallpaper found in theme"
fi

# Reload Apps
log_info "Reloading applications..."

# Hyprland (reloads config)
if pgrep -x "Hyprland" >/dev/null; then
    hyprctl reload >/dev/null
    log_success "Hyprland reloaded"
fi

# Waybar (SIGUSR2 reloads style)
if pgrep -x "waybar" >/dev/null; then
    killall -SIGUSR2 waybar
    log_success "Waybar reloaded"
fi

# Dunst (kill to restart via systemd or autostart)
if pgrep -x "dunst" >/dev/null; then
    killall dunst
    # It should auto-start when notified, or we can start it
    notify-send "Theme Changed" "Switched to $THEME_NAME"
    log_success "Dunst reloaded"
fi

log_success "Theme switch complete!"














