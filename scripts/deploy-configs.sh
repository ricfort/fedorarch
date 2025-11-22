#!/usr/bin/env bash
set -euo pipefail

echo "=== Deploying configurations ==="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
STOW_DIR="$REPO_ROOT/stow"

if [ ! -d "$STOW_DIR" ]; then
    echo "Error: stow directory not found at $STOW_DIR"
    exit 1
fi

# Ensure stow is installed
if ! command -v stow >/dev/null 2>&1; then
    echo "Error: stow is not installed"
    exit 1
fi

# Clean up broken symlinks first
echo "Cleaning up broken symlinks..."
find ~/.config -type l ! -exec test -e {} \; -delete 2>/dev/null || true
find ~/.local/bin -type l ! -exec test -e {} \; -delete 2>/dev/null || true
find ~/.local/share -type l ! -exec test -e {} \; -delete 2>/dev/null || true

# Function to ensure target directory exists
ensure_target_dir() {
    local package_name="$1"
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
        lazydocker)
            mkdir -p ~/.config/lazydocker
            ;;
        lazygit)
            mkdir -p ~/.config/lazygit
            ;;
        uv)
            mkdir -p ~/.config/uv
            ;;
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
    # Stow output format: "WARNING! stowing <package> would cause conflicts:"
    # followed by lines like "  * existing target is neither a link nor a directory: <path>"
    # Paths in stow output are relative to the target directory (~)
    local conflicts=$(grep -A 100 "would cause conflicts" "$stow_log" 2>/dev/null | \
                     grep "existing target" | \
                     sed 's/.*existing target.*: //' | \
                     sed 's/^[[:space:]]*//' | \
                     sed 's/[[:space:]]*$//' | \
                     grep -v '^$')
    
    if [ -z "$conflicts" ]; then
        return 0
    fi
    
    echo "    Resolving conflicts for $package_name..."
    local backup_dir="$HOME/.config.backup-$(date +%Y%m%d-%H%M%S)-$package_name"
    mkdir -p "$backup_dir"
    
    echo "$conflicts" | while IFS= read -r conflict_rel; do
        # Skip empty lines
        [ -z "$conflict_rel" ] && continue
        
        # Build absolute path (stow paths are relative to target ~)
        local conflict_path="$HOME/$conflict_rel"
        
        # Safety check: Only process files in allowed directories
        local allowed=false
        for allowed_path in "${ALLOWED_PATHS[@]}"; do
            if [[ "$conflict_path" == "$allowed_path"* ]]; then
                allowed=true
                break
            fi
        done
        
        if [ "$allowed" = false ]; then
            echo "      ⚠ Skipping $conflict_path (outside allowed directories)"
            continue
        fi
        
        # Only process if it exists and is not a symlink
        if [ -e "$conflict_path" ] && [ ! -L "$conflict_path" ]; then
            # Get relative path for backup
            local rel_path="${conflict_path#$HOME/}"
            local backup_path="$backup_dir/$rel_path"
            
            # Create backup directory structure
            mkdir -p "$(dirname "$backup_path")"
            
            # Backup the conflicting file/directory
            echo "      Backing up: $conflict_path"
            cp -r "$conflict_path" "$backup_path" 2>/dev/null || {
                echo "      ⚠ Failed to backup $conflict_path"
                continue
            }
            
            # Remove the conflicting file/directory
            echo "      Removing: $conflict_path"
            rm -rf "$conflict_path" 2>/dev/null || {
                echo "      ⚠ Failed to remove $conflict_path"
            }
        fi
    done
    
    echo "    Conflicts backed up to: $backup_dir"
}

# Stow each directory
cd "$STOW_DIR"
for dir in */; do
    [ -d "$dir" ] || continue
    package_name=$(basename "$dir")
    
    echo "Deploying $package_name..."
    
    # Ensure target directory exists
    ensure_target_dir "$package_name"
    
    # Unstow first to avoid conflicts (removes existing symlinks)
    stow -D -d "$STOW_DIR" -t ~ "$package_name" 2>/dev/null || true
    
    # Try to stow - if it fails due to conflicts, resolve them
    STOW_LOG="/tmp/stow_${package_name}.log"
    
    # First, try a dry-run to detect conflicts
    if ! stow -n -d "$STOW_DIR" -t ~ "$package_name" > "$STOW_LOG" 2>&1; then
        if grep -q "would cause conflicts\|conflicts" "$STOW_LOG" 2>/dev/null; then
            echo "  ⚠ Conflicts detected for $package_name, resolving..."
            echo "    Showing conflicts:"
            grep -A 5 "would cause conflicts" "$STOW_LOG" | head -10
            resolve_conflicts "$package_name" "$STOW_LOG"
        fi
    fi
    
    # Now try actual stowing
    if ! stow -d "$STOW_DIR" -t ~ "$package_name" > "$STOW_LOG" 2>&1; then
        echo "  ✗ Failed to deploy $package_name"
        echo "    Error details:"
        cat "$STOW_LOG" | head -20
        echo ""
        echo "    Full log saved to: $STOW_LOG"
        echo "    You may need to manually resolve conflicts"
    else
        echo "  ✓ Successfully deployed $package_name"
        rm -f "$STOW_LOG"
    fi
done

# Make scripts executable
if [ -d ~/.local/bin ]; then
    echo "Making scripts executable..."
    chmod +x ~/.local/bin/* 2>/dev/null || true
fi

echo "=== Configuration deployment complete ==="

