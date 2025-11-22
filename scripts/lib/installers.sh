#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Check if a DNF package is installed
is_dnf_installed() {
    rpm -q "$1" >/dev/null 2>&1
}

# Install standard DNF packages
install_dnf() {
    local packages=("$@")
    install_dnf_opts "" "${packages[@]}"
}

# Install DNF packages with options
# Usage: install_dnf_opts "--exclude=foo" "pkg1" "pkg2"
install_dnf_opts() {
    local opts="$1"
    shift
    local packages=("$@")
    local to_install=()

    for pkg in "${packages[@]}"; do
        if ! is_dnf_installed "$pkg"; then
            to_install+=("$pkg")
        else
            log_info "Package $pkg already installed"
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        log_info "Installing packages: ${to_install[*]}"
        # We use eval/expansion carefully here, but opts is trusted from our scripts
        run_sudo dnf install -y $opts "${to_install[@]}"
    fi
}

# Enable COPR repository
enable_copr() {
    local repo="$1"
    if dnf copr list enabled 2>/dev/null | grep -q "^$repo"; then
        log_info "COPR repo $repo already enabled"
    else
        log_info "Enabling COPR repo: $repo"
        run_sudo dnf copr enable -y "$repo"
    fi
}

# Install Flatpak package
install_flatpak() {
    local remote="$1"
    local app_id="$2"

    if ! check_command flatpak; then
        log_warn "Flatpak not installed, installing..."
        install_dnf "flatpak"
    fi

    # Add remote if needed
    if ! flatpak remote-list | grep -q "$remote"; then
        log_info "Adding Flatpak remote: $remote"
        run_cmd flatpak remote-add --if-not-exists "$remote" "https://dl.flathub.org/repo/flathub.flatpakrepo"
    fi

    if ! flatpak list | grep -q "$app_id"; then
        log_info "Installing Flatpak: $app_id"
        run_cmd flatpak install -y "$remote" "$app_id"
    else
        log_info "Flatpak $app_id already installed"
    fi
}

# Generic URL installer (download, extract, move)
# Usage: install_from_url "name" "url" "binary_name" "install_path" "archive_binary_name"
install_from_url() {
    local name="$1"
    local url="$2"
    local binary_name="$3"
    local install_path="${4:-$HOME/.local/bin}"
    local archive_binary_name="${5:-$binary_name}"
    
    if check_command "$binary_name" || [ -f "$install_path/$binary_name" ]; then
        log_info "$name already installed"
        return 0
    fi

    log_info "Installing $name from $url..."
    
    local tmp_dir=$(mktemp -d)
    local filename=$(basename "$url")
    
    run_cmd curl -L -o "$tmp_dir/$filename" "$url"
    
    cd "$tmp_dir"
    if [[ "$filename" == *.tar.gz ]] || [[ "$filename" == *.tgz ]]; then
        run_cmd tar -xzf "$filename"
    elif [[ "$filename" == *.zip ]]; then
        run_cmd unzip -q "$filename"
    fi
    
    # Find binary
    local binary_found=$(find . -type f -name "$archive_binary_name" | head -n 1)
    if [ -n "$binary_found" ]; then
        run_cmd mkdir -p "$install_path"
        run_cmd mv "$binary_found" "$install_path/$binary_name"
        run_cmd chmod +x "$install_path/$binary_name"
        log_success "$name installed to $install_path/$binary_name"
    else
        log_error "Could not find binary $archive_binary_name in archive"
        # List files to help debug
        find . -type f
    fi
    
    run_cmd rm -rf "$tmp_dir"
}

# Install mise
install_mise() {
    if ! check_command mise && [ ! -f ~/.local/bin/mise ]; then
        log_info "Installing mise..."
        run_cmd curl -fsSL https://mise.jdx.dev/install.sh | sh
        export PATH="$HOME/.local/bin:$PATH"
    else
        log_info "mise already installed"
    fi
}

# Install uv
install_uv() {
    if ! check_command uv && [ ! -f ~/.local/bin/uv ]; then
        log_info "Installing uv..."
        run_cmd curl -LsSf https://astral.sh/uv/install.sh | sh
        export PATH="$HOME/.local/bin:$PATH"
    else
        log_info "uv already installed"
    fi
}

