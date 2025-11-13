#!/usr/bin/env bash
set -e

echo "Deploying fedorarch rice..."

# Packages
sudo dnf install -y \
    hyprland hyprpaper hypridle hyprpicker hyprcursor \
    xdg-desktop-portal-hyprland waybar tofi \
    cliphist wl-clip-persist wl-clipboard grim slurp satty \
    dunst alacritty thunar sddm fprintd \
    jetbrains-mono-fonts fontawesome6-fonts nerd-fonts \
    qt5-qtwayland qt6-qtwayland \
    neovim lazygit lazydocker python3-pip python3-devel \
    nodejs npm gcc gcc-c++ make

sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda || true

# mise + uv
curl https://mise.jdx.dev/install.sh | sh
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash)"
mise install python@latest nodejs@latest
mise use python@latest nodejs@latest
uv tool install ruff black debugpy --global

# Services
sudo systemctl enable sddm --force
sudo authselect enable-feature with-fingerprint || true

# Cliphist
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/cliphist.service << 'EOF'
[Unit] Description=Cliphist
[Service] ExecStart=/usr/bin/cliphist store Restart=always
[Install] WantedBy=default.target
EOF
systemctl --user enable --now cliphist.service

# Stow
stow --adopt -v stow/*

chmod +x ~/.local/bin/* 2>/dev/null || true
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

echo "Rebooting in 10s..."
sleep 10 && reboot
