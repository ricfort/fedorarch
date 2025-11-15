#!/usr/bin/env bash
set -euo pipefail

echo "=== Backing up existing configurations ==="

BACKUP_DIR="$HOME/.config.backup-$(date +%Y%m%d-%H%M%S)"
DIRS_TO_BACKUP=(
    "$HOME/.config"
    "$HOME/.local/bin"
    "$HOME/.local/share/applications"
)

# Check if any of these directories have non-symlink files
HAS_FILES_TO_BACKUP=false
for dir in "${DIRS_TO_BACKUP[@]}"; do
    if [ -d "$dir" ]; then
        # Check for non-symlink files
        if find "$dir" -type f ! -type l 2>/dev/null | grep -q .; then
            HAS_FILES_TO_BACKUP=true
            break
        fi
    fi
done

if [ "$HAS_FILES_TO_BACKUP" = false ]; then
    echo "No existing configuration files to backup"
    exit 0
fi

echo "Creating backup directory: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Backup each directory if it exists and has files
for dir in "${DIRS_TO_BACKUP[@]}"; do
    if [ -d "$dir" ]; then
        # Only backup if there are actual files (not just symlinks)
        if find "$dir" -type f ! -type l 2>/dev/null | grep -q .; then
            dir_name=$(basename "$dir")
            echo "Backing up $dir to $BACKUP_DIR/$dir_name"
            cp -r "$dir" "$BACKUP_DIR/$dir_name" 2>/dev/null || {
                echo "Warning: Failed to backup $dir"
            }
        fi
    fi
done

# Also backup specific config files that might exist
CONFIG_FILES=(
    "$HOME/.bashrc"
    "$HOME/.zshrc"
    "$HOME/.profile"
)

for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$file" ] && ! [ -L "$file" ]; then
        echo "Backing up $file"
        cp "$file" "$BACKUP_DIR/$(basename $file)" 2>/dev/null || true
    fi
done

echo "Backup complete: $BACKUP_DIR"
echo "You can restore files from this backup if needed"

