#!/usr/bin/env bash
set -euo pipefail

# Source libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

echo "=== Add New Package ==="

CONFIG_FILE="$SCRIPT_DIR/config/packages.sh"

# List categories
echo "Select a category to add the package to:"
echo "1) Core Hyprland (HYPRLAND_PACKAGES)"
echo "2) Essential Apps (ESSENTIAL_PACKAGES)"
echo "3) Utilities (UTILITY_PACKAGES)"
echo "4) Development (DEV_PACKAGES)"
echo "5) Fonts (FONT_PACKAGES)"
echo "6) Other/New"

read -p "Choice [2]: " choice
choice=${choice:-2}

case "$choice" in
    1) ARRAY="HYPRLAND_PACKAGES" ;;
    2) ARRAY="ESSENTIAL_PACKAGES" ;;
    3) ARRAY="UTILITY_PACKAGES" ;;
    4) ARRAY="DEV_PACKAGES" ;;
    5) ARRAY="FONT_PACKAGES" ;;
    *) ARRAY="ESSENTIAL_PACKAGES" ;;
esac

echo ""
read -p "Enter package name (dnf name): " pkg_name

if [ -z "$pkg_name" ]; then
    log_error "Package name cannot be empty"
    exit 1
fi

# Sanitize package name - only allow alphanumeric, dash, underscore, and dot
if ! [[ "$pkg_name" =~ ^[a-zA-Z0-9._+-]+$ ]]; then
    log_error "Invalid package name. Only alphanumeric characters, dots, dashes, underscores, and plus signs are allowed."
    exit 1
fi

# Verify package exists before attempting install
if ! dnf info "$pkg_name" >/dev/null 2>&1; then
    log_error "Package '$pkg_name' not found in repositories"
    log_info "Try: dnf search $pkg_name"
    exit 1
fi

# Install first to verify
log_info "Attempting to install $pkg_name..."
if sudo dnf install -y "$pkg_name"; then
    log_success "Package installed successfully"
    
    # Add to config file
    # We look for the array definition and insert the new package before the closing parenthesis
    log_info "Adding to configuration ($ARRAY)..."
    
    # Create a temporary file
    TMP_FILE=$(mktemp)
    
    # Use awk to insert the line
    awk -v pkg="    \"$pkg_name\"" -v arr="$ARRAY=(" '
    $0 ~ arr { in_array = 1; print; next }
    in_array && /^\)/ { print pkg; in_array = 0 }
    { print }
    ' "$CONFIG_FILE" > "$TMP_FILE"
    
    # Verify change
    if diff "$CONFIG_FILE" "$TMP_FILE" >/dev/null; then
        log_warn "Could not automatically add to config file (pattern match failed)."
        log_warn "Please manually add \"$pkg_name\" to $ARRAY in $CONFIG_FILE"
    else
        mv "$TMP_FILE" "$CONFIG_FILE"
        log_success "Added $pkg_name to $CONFIG_FILE"
    fi
    rm -f "$TMP_FILE"
    
else
    log_error "Failed to install package. Not adding to config."
    exit 1
fi


