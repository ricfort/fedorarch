# Fedorarch - Fedora Omarchy Rice

# STILL WIP

A dotfiles repository for configuring Fedora with Hyprland in an Arch-style setup.

## Quick Start

### Initial Setup

```bash
curl -fsSL https://raw.githubusercontent.com/ricfort/fedorarch/main/bootstrap.sh | bash
```

Or clone manually:

```bash
git clone git@github.com:ricfort/fedorarch.git ~/fedorarch
cd ~/fedorarch
./install.sh
```

## Updating After Pulling Changes

### Option 1: Use the Update Script (Recommended)

```bash
cd ~/fedorarch
./update.sh
```

This script will:
- Pull the latest changes from git
- Re-stow all dotfiles
- Make scripts executable

### Option 2: Manual Update

```bash
cd ~/fedorarch
git pull

# Re-stow all directories
stow -v -d stow -t ~ */
```

Or re-stow specific directories:

```bash
stow -v -d stow -t ~ hyprland
stow -v -d stow -t ~ waybar
# etc...
```

### After Updating

Some changes may require restarting services:

- **Hyprland**: Reload config with `hyprctl reload` or restart Hyprland
- **Waybar**: Restart waybar (`killall waybar; waybar &`)
- **Systemd user services**: `systemctl --user daemon-reload`

## Directory Structure

```
fedorarch/
├── bootstrap.sh      # Initial system setup
├── install.sh        # Main installation script
├── update.sh         # Update script for pulling changes
└── stow/             # Dotfiles organized by application
    ├── alacritty/
    ├── bin/
    ├── cliphist/
    ├── hyprland/
    ├── hyprland-keys/
    ├── lazydocker/
    ├── lazygit/
    ├── mise/
    ├── nvim/
    ├── uv/
    └── waybar/
```

## Key Bindings

- `Super + Space`: Application launcher (tofi)
- `Super + Return`: Terminal (alacritty)
- `Super + K`: Show keybinds
- `Super + V`: Clipboard menu
- `Super + G`: LazyGit
- `Super + D`: LazyDocker
- `Super + N`: Neovim
- `Super + P`: Python project setup
- `Super + 1-9`: Switch workspaces
- `Super + Shift + 1-9`: Move window to workspace

## Customization

Edit config files in the `stow/` directories, then re-stow:

```bash
stow -v -d stow -t ~ <directory-name>
```

## Troubleshooting

### Stow Conflicts

If you get "conflicts" errors when stowing:
1. The scripts now automatically unstow before re-stowing
2. Broken symlinks are automatically cleaned up
3. If conflicts persist, manually backup and remove conflicting files:
   ```bash
   # Backup existing config
   mv ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.backup
   # Then re-stow
   stow -d stow -t ~ hyprland
   ```

### Broken Config Directory

If you can't open terminal or get "broken config dir":
1. **Access TTY**: Press `Ctrl+Alt+F2` to get a text console
2. **Clean up broken symlinks**:
   ```bash
   find ~/.config -type l ! -exec test -e {} \; -delete
   find ~/.local/bin -type l ! -exec test -e {} \; -delete
   ```
3. **Re-stow from repo**:
   ```bash
   cd ~/fedorarch
   ./update.sh
   ```

### Other Issues

- Check logs: `journalctl --user -u cliphist.service`
- Verify Hyprland config: `hyprctl reload` will show errors if any
- Validate configs: Run `bash validate-configs.sh` before stowing

