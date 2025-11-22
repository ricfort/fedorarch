#!/usr/bin/env bash

# Simple test runner for library functions
# Run with: ./tests/test_libs.sh

set -e

# Mock sudo for testing if not root
if [ "$EUID" -ne 0 ]; then
    sudo() {
        echo "sudo $@"
    }
    export -f sudo
fi

# Source libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
source "$PROJECT_ROOT/scripts/lib/common.sh"
source "$PROJECT_ROOT/scripts/lib/installers.sh"

echo "=== Running Library Tests ==="

# Test 1: Logging functions
echo "Testing logging..."
log_info "This is an info message"
log_success "This is a success message"
log_warn "This is a warning message"
log_error "This is an error message"

# Test 2: DRY_RUN
echo "Testing DRY_RUN..."
export DRY_RUN=1
log_info "Enabling DRY_RUN mode"
run_cmd echo "This command should not run, but be printed"
run_sudo echo "This sudo command should not run, but be printed"

# Capture output to verify DRY_RUN behavior
# We match partially to avoid color code complexity
OUTPUT=$(run_cmd echo "test" 2>&1)
if [[ "$OUTPUT" != *"[DRY_RUN]"* ]] || [[ "$OUTPUT" != *"echo test"* ]]; then
    echo "FAIL: DRY_RUN output unexpected: $OUTPUT"
    exit 1
else
    echo "PASS: DRY_RUN working"
fi

unset DRY_RUN

# Test 3: check_command
echo "Testing check_command..."
if check_command "bash"; then
    echo "PASS: bash found"
else
    echo "FAIL: bash not found"
    exit 1
fi

if check_command "nonexistentcommand12345"; then
    echo "FAIL: nonexistent command found"
    exit 1
else
    echo "PASS: nonexistent command not found"
fi

# Test 4: Configuration loading
echo "Testing config loading..."
source "$PROJECT_ROOT/scripts/config/packages.sh"
source "$PROJECT_ROOT/scripts/config/repos.sh"

if [ ${#ESSENTIAL_PACKAGES[@]} -gt 0 ]; then
    echo "PASS: ESSENTIAL_PACKAGES loaded (${#ESSENTIAL_PACKAGES[@]} items)"
else
    echo "FAIL: ESSENTIAL_PACKAGES empty"
    exit 1
fi

if [ ${#COPR_REPOS[@]} -gt 0 ]; then
    echo "PASS: COPR_REPOS loaded (${#COPR_REPOS[@]} items)"
else
    echo "FAIL: COPR_REPOS empty"
    exit 1
fi

echo "=== All Tests Passed ==="

