#!/usr/bin/env bash
set -euo pipefail

# Source libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

echo "=== Deploying configurations ==="

REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
STOW_DIR="$REPO_ROOT/stow"

if [ ! -d "$STOW_DIR" ]; then
    log_error "stow directory not found at $STOW_DIR"
    exit 1
fi

# Ensure stow is installed
if ! check_command stow; then
    log_error "stow is not installed"
    exit 1
fi

# Clean up broken symlinks first
log_info "Cleaning up broken symlinks..."
find ~/.config -type l ! -exec test -e {} \; -delete 2>/dev/null || true
find ~/.local/bin -type l ! -exec test -e {} \; -delete 2>/dev/null || true
find ~/.local/share -type l ! -exec test -e {} \; -delete 2>/dev/null || true

# Function to ensure target directory exists
ensure_target_dir() {
    local package_name="$1"
    case "$package_name" in
        ghostty) mkdir -p ~/.config/ghostty ;;
        hyprland|hyprland-keys) mkdir -p ~/.config/hypr ;;
        waybar) mkdir -p ~/.config/waybar ;;
        nvim) mkdir -p ~/.config/nvim ;;
        cliphist) mkdir -p ~/.config/cliphist ;;
        tofi) mkdir -p ~/.config/tofi ;;
        mise) mkdir -p ~/.config/mise ;;
        bin) mkdir -p ~/.local/bin ;;
        lazydocker) mkdir -p ~/.config/lazydocker ;;
        lazygit) mkdir -p ~/.config/lazygit ;;
        uv) mkdir -p ~/.config/uv ;;
        webapps)
            mkdir -p ~/.local/share/applications
            mkdir -p ~/.local/share/icons/webapps
            ;;
    esac
}

# Function to resolve conflicts by backing up and removing conflicting files
resolve_conflicts() {
    local package_name="$1"
    local stow_log="$2"
    
    # Safety: Only allow operations in expected config directories
    local ALLOWED_PATHS=(
        "$HOME/.config"
        "$HOME/.local/bin"
        "$HOME/.local/share"
    )
    
    # Extract conflicting file paths from stow output
    local conflicts=$(grep -A 100 "would cause conflicts" "$stow_log" 2>/dev/null | \
                     grep "existing target" | \
                     sed 's/.*existing target.*: //' | \
                     sed 's/^[[:space:]]*//' | \
                     sed 's/^[[:space:]]*$//' | \
                     grep -v '^$')
    
    if [ -z "$conflicts" ]; then
        return 0
    fi
    
    log_info "    Resolving conflicts for $package_name..."
    local backup_dir="$HOME/.config.backup-$(date +%Y%m%d-%H%M%S)-$package_name"
    mkdir -p "$backup_dir"
    
    echo "$conflicts" | while IFS= read -r conflict_rel; do
        [ -z "$conflict_rel" ] && continue
        
        local conflict_path="$HOME/$conflict_rel"
        local allowed=false
        for allowed_path in "${ALLOWED_PATHS[@]}"; do
            if [[ "$conflict_path" == "$allowed_path"* ]]; then
                allowed=true
                break
            fi
        done
        
        if [ "$allowed" = false ]; then
            log_warn "      Skipping $conflict_path (outside allowed directories)"
            continue
        fi
        
        if [ -e "$conflict_path" ] && [ ! -L "$conflict_path" ]; then
            local rel_path="${conflict_path#$HOME/}"
            local backup_path="$backup_dir/$rel_path"
            
            mkdir -p "$(dirname "$backup_path")"
            log_info "      Backing up: $conflict_path"
            cp -r "$conflict_path" "$backup_path" 2>/dev/null || {
                log_warn "      Failed to backup $conflict_path"
                continue
            }
            
            log_info "      Removing: $conflict_path"
            rm -rf "$conflict_path" 2>/dev/null || {
                log_warn "      Failed to remove $conflict_path"
            }
        fi
    done
    
    log_success "    Conflicts backed up to: $backup_dir"
}

# Stow each directory
cd "$STOW_DIR"
for dir in */; do
    [ -d "$dir" ] || continue
    package_name=$(basename "$dir")
    
    log_info "Deploying $package_name..."
    ensure_target_dir "$package_name"
    
    # Unstow first
    stow -D -d "$STOW_DIR" -t ~ "$package_name" 2>/dev/null || true
    
    STOW_LOG="/tmp/stow_${package_name}.log"
    
    # Dry-run to detect conflicts
    if ! stow -n -d "$STOW_DIR" -t ~ "$package_name" > "$STOW_LOG" 2>&1; then
        if grep -q "would cause conflicts\|conflicts" "$STOW_LOG" 2>/dev/null; then
            log_warn "  Conflicts detected for $package_name, resolving..."
            resolve_conflicts "$package_name" "$STOW_LOG"
        fi
    fi
    
    # Actual stowing
    if ! stow -d "$STOW_DIR" -t ~ "$package_name" > "$STOW_LOG" 2>&1; then
        log_error "  Failed to deploy $package_name"
        cat "$STOW_LOG" | head -20
        log_error "    Full log saved to: $STOW_LOG"
    else
        log_success "  Successfully deployed $package_name"
        rm -f "$STOW_LOG"
    fi
done

# Make scripts executable
if [ -d ~/.local/bin ]; then
    log_info "Making scripts executable..."
    chmod +x ~/.local/bin/* 2>/dev/null || true
fi

# Reload Hyprland if running
if pgrep -x "Hyprland" >/dev/null; then
    log_info "Reloading Hyprland..."
    hyprctl reload >/dev/null 2>&1 && log_success "Hyprland reloaded" || log_warn "Failed to reload Hyprland"
fi

log_success "Configuration deployment complete"

