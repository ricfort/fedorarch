#!/usr/bin/env bash
set -e

echo "Fedora → Omarchy-Grade Rice Bootstrap (2025)"
echo "Installing git, curl, stow..."

sudo dnf update -y
sudo dnf install -y git curl stow openssh-clients

# Git config
read -p "Your git username: " name
read -p "Your git email: " email
git config --global user.name "$name"
git config --global user.email "$email"
git config --global init.defaultBranch main

# SSH key
if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -N ""
    echo "Add to GitHub:"
    cat ~/.ssh/id_ed25519.pub
    read -p "Press Enter when done..."
fi

# === CLONE fedorarch ===
REPO_SSH="git@github.com:ricfort/fedorarch.git"
REPO_HTTPS="https://github.com/ricfort/fedorarch.git"

echo "Cloning fedorarch..."
cd ~
if git clone "$REPO_SSH" fedorarch 2>/dev/null; then
    echo "Cloned via SSH"
else
    echo "SSH failed. Trying HTTPS..."
    git clone "$REPO_HTTPS" fedorarch
fi

cd fedorarch
chmod +x install.sh

# === RUN INSTALL ===
echo "Running install.sh..."
./install.sh
