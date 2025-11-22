#!/usr/bin/env bash
set -euo pipefail

# Source libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

echo "=== Backing up existing configurations ==="

BACKUP_DIR="$HOME/.config.backup-$(date +%Y%m%d-%H%M%S)"
DIRS_TO_BACKUP=(
    "$HOME/.config"
    "$HOME/.local/bin"
    "$HOME/.local/share/applications"
)

# Check for files to backup
HAS_FILES_TO_BACKUP=false
for dir in "${DIRS_TO_BACKUP[@]}"; do
    if [ -d "$dir" ]; then
        if find "$dir" -type f ! -type l 2>/dev/null | grep -q .; then
            HAS_FILES_TO_BACKUP=true
            break
        fi
    fi
done

if [ "$HAS_FILES_TO_BACKUP" = false ]; then
    log_info "No existing configuration files to backup"
    exit 0
fi

log_info "Creating backup directory: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Backup directories
for dir in "${DIRS_TO_BACKUP[@]}"; do
    if [ -d "$dir" ]; then
        if find "$dir" -type f ! -type l 2>/dev/null | grep -q .; then
            dir_name=$(basename "$dir")
            log_info "Backing up $dir to $BACKUP_DIR/$dir_name"
            cp -r "$dir" "$BACKUP_DIR/$dir_name" 2>/dev/null || {
                log_warn "Failed to backup $dir"
            }
        fi
    fi
done

# Backup individual config files
CONFIG_FILES=(
    "$HOME/.bashrc"
    "$HOME/.zshrc"
    "$HOME/.profile"
)

for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$file" ] && ! [ -L "$file" ]; then
        log_info "Backing up $file"
        cp "$file" "$BACKUP_DIR/$(basename $file)" 2>/dev/null || true
    fi
done

log_success "Backup complete: $BACKUP_DIR"
