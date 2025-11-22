#!/usr/bin/env bash
# Simple config validation and integrity script
# Run this to ensure the repo structure and scripts are valid

set -e

# Source libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/lib/common.sh"

echo "=== Validating Repository Integrity ==="

ERRORS=0

check_result() {
    if [ $1 -eq 0 ]; then
        log_success "$2"
    else
        log_error "$2"
        ERRORS=$((ERRORS + 1))
    fi
}

# 1. Check Script Syntax (basic bash -n)
log_info "Checking shell script syntax..."
find "$SCRIPT_DIR" -name "*.sh" -type f | while read -r script; do
    if bash -n "$script"; then
        # Quiet success
        true
    else
        log_error "Syntax error in $script"
        ERRORS=$((ERRORS + 1))
    fi
done
check_result $? "Shell script syntax check"

# 2. Validate Hyprland config existence
if [ -f "$SCRIPT_DIR/stow/hyprland/.config/hypr/hyprland.conf" ]; then
    log_success "Hyprland config found"
    # Check for vital configs
    if grep -q "^monitor=" "$SCRIPT_DIR/stow/hyprland/.config/hypr/hyprland.conf"; then
        log_success "Hyprland monitor config found"
    else
        log_warn "Hyprland monitor config missing"
    fi
else
    log_error "Hyprland config missing"
    ERRORS=$((ERRORS + 1))
fi

# 3. Check Stow Directory Structure
log_info "Checking stow directories..."
if [ -d "$SCRIPT_DIR/stow" ]; then
    for dir in "$SCRIPT_DIR/stow"/*/; do
        [ -d "$dir" ] || continue
        package_name=$(basename "$dir")
        # Check if package directory is not empty
        if [ -z "$(ls -A "$dir")" ]; then
            log_warn "Stow package $package_name is empty"
        fi
    done
else
    log_error "Stow directory missing"
    ERRORS=$((ERRORS + 1))
fi

# 4. Check Config Files
log_info "Checking config definitions..."
if [ -f "$SCRIPT_DIR/scripts/config/packages.sh" ] && [ -f "$SCRIPT_DIR/scripts/config/repos.sh" ]; then
    log_success "Config definitions found"
else
    log_error "Config definitions missing"
    ERRORS=$((ERRORS + 1))
fi

# Summary
echo ""
if [ $ERRORS -eq 0 ]; then
    log_success "✓ All checks passed"
    exit 0
else
    log_error "✗ Found $ERRORS error(s)"
    exit 1
fi
