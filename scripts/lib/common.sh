#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

ensure_sudo() {
    if ! sudo -n true 2>/dev/null; then
        log_warn "Sudo access required. Please enter password:"
        sudo -v
    fi
}

check_command() {
    command -v "$1" >/dev/null 2>&1
}

check_file() {
    [ -f "$1" ]
}

check_dir() {
    [ -d "$1" ]
}

# Wrapper for executing commands (supports DRY_RUN)
run_cmd() {
    if [ "${DRY_RUN:-0}" -eq 1 ]; then
        echo -e "${YELLOW}[DRY_RUN]${NC} $@"
    else
        "$@"
    fi
}

# Wrapper for sudo commands (supports DRY_RUN)
run_sudo() {
    if [ "${DRY_RUN:-0}" -eq 1 ]; then
        echo -e "${YELLOW}[DRY_RUN]${NC} sudo $@"
    else
        sudo "$@"
    fi
}

enable_service() {
    local service="$1"
    if systemctl is-enabled "$service" >/dev/null 2>&1; then
        log_info "Service $service already enabled"
    else
        log_info "Enabling service $service..."
        run_sudo systemctl enable "$service" --force
    fi
}

start_service() {
    local service="$1"
    if systemctl is-active "$service" >/dev/null 2>&1; then
        log_info "Service $service already running"
    else
        log_info "Starting service $service..."
        run_sudo systemctl start "$service"
    fi
}

enable_user_service() {
    local service="$1"
    if systemctl --user is-enabled "$service" >/dev/null 2>&1; then
        log_info "User service $service already enabled"
    else
        log_info "Enabling user service $service..."
        run_cmd systemctl --user enable "$service"
    fi
}

start_user_service() {
    local service="$1"
    if systemctl --user is-active "$service" >/dev/null 2>&1; then
        log_info "User service $service already running"
    else
        log_info "Starting user service $service..."
        run_cmd systemctl --user start "$service"
    fi
}

