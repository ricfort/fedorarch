# Fedorarch

**Fedorarch** is a modular, Omarchy-style configuration framework for **Fedora Linux**. It provides a polished, keyboard-centric Wayland environment powered by **Hyprland**, with a focus on maintainability, modularity, and ease of use.

## 📸 Screenshots

![Desktop Overview](screenshots/screenshot-area-20251123-095117.png)
*Main desktop with Hyprland, Waybar, and wallpaper*

![Application Launcher](screenshots/screenshot-area-20251123-095202.png)
*Tofi application launcher (Super+Space)*

![Development Tools](screenshots/screenshot-area-20251123-095217.png)
*Ghostty terminal with development environment*

![System Overview](screenshots/screenshot-area-20251123-095642.png)
*Multi-monitor workspace setup*

## 🚀 Features

### Core Components
*   **Window Manager:** Hyprland (Wayland) with "dwindle" layout
*   **Terminal:** Ghostty - fast, GPU-accelerated with ligature support
*   **Launcher:** Tofi - minimal Wayland-native application launcher
*   **Bar:** Waybar - highly customizable status bar with custom widgets
*   **Notifications:** Dunst with custom theme integration
*   **Shell:** Zsh with Starship prompt

### Development Environment
*   **Editor:** Neovim with modern plugins
*   **Version Control:** Lazygit for interactive Git management
*   **Containers:** Lazydocker for Docker management
*   **Language Management:** Mise for Python, Node.js, Go, etc.
*   **Python Tools:** UV for fast package installation

### Key Features
*   **Modular Design:** Clean separation of logic (`scripts/lib`) and configuration (`scripts/config`)
*   **Safe Installation:** DRY_RUN mode and validation scripts
*   **Multi-Monitor Support:** Dynamic workspace distribution across monitors
*   **Theme System:** Easy switching between visual themes
*   **Web Apps:** Create standalone desktop apps from websites
*   **Profile Management:** Separate Chromium profiles for Personal/Work
*   **Clipboard History:** Persistent clipboard with cliphist

## 📦 Installation

### Prerequisites
*   A fresh install of Fedora Workstation (recommended) or Server.
*   Internet connection.

### One-Line Bootstrap
```bash
curl -fsSL https://raw.githubusercontent.com/ricfort/fedorarch/main/bootstrap.sh | bash
```

### Manual Installation
1.  Clone the repository:
    ```bash
    git clone https://github.com/ricfort/fedorarch.git ~/fedorarch
    cd ~/fedorarch
    ```
2.  Run the bootstrap script:
    ```bash
    ./bootstrap.sh
    ```

## 🛠 Configuration

The project is designed to be modular. You don't need to edit complex scripts to change what gets installed.

### Managing Packages
Edit `scripts/config/packages.sh` to add or remove standard Fedora packages.
To add a package interactively:
```bash
./scripts/add-package.sh
```

### Managing Repositories
Edit `scripts/config/repos.sh` to manage COPR repositories.

### Monitor Configuration
Configure your monitors by running:
```bash
./scripts/configure-monitors.sh
```

Or manually edit `~/.config/hypr/monitors.conf`. Example configuration:
```conf
# Primary monitor (2560x1440 @ 144Hz)
monitor=DP-1,2560x1440@144,0x0,1

# Secondary monitor (1920x1080 @ 60Hz)
monitor=HDMI-A-1,1920x1080@60,2560x0,1

# Laptop screen
monitor=eDP-1,1920x1200@60,0x1440,1
```

To see your connected monitors, run: `hyprctl monitors`

#### Workspace Distribution
Workspaces are automatically distributed across your monitors:
- **1 Monitor:** All workspaces (1-10) available on single monitor
- **2 Monitors:** Workspaces 1-5 on first monitor, 6-10 on second
- **3+ Monitors:** Evenly distributed across all displays

To reset workspace distribution after connecting/disconnecting monitors:
```bash
reset-workspaces.sh
```

**Workspace Navigation:**
- `Super + [1-9]` - Switch to workspace 1-9
- `Super + Shift + [1-9]` - Move active window to workspace
- `Super + Mouse Wheel` - Cycle through workspaces

### User Overrides
Edit `~/.config/hypr/user.conf` for custom keybinds or rules. This file is sourced last and takes precedence over default settings.

### Chromium Profiles & Web Apps

#### Multi-Profile Workflow
The configuration supports separate Chromium profiles for different contexts:

*   **Personal Profile:** `Super + B` - For personal browsing, social media, entertainment
*   **Work Profile:** `Super + Shift + B` - For work accounts, professional tools

Each profile maintains separate:
- Cookies and session data
- Extensions
- Bookmarks
- History
- Themes and settings

#### Creating Web Apps (Site-Specific Browsers)
Turn any website into a standalone desktop application:

```bash
make-webapp
```

The interactive wizard will prompt for:
1.  **Name:** Display name (e.g., "Gmail", "Slack")
2.  **URL:** Website URL (https://mail.google.com)
3.  **Icon:** Optional icon URL for custom branding
4.  **Profile:** Choose Personal or Work profile

**Benefits:**
- Appears in `Super + Space` launcher as native app
- Isolated from browser tabs
- No window decorations (clean, distraction-free)
- Separate from main browser session
- Custom Hyprland window rules can be applied

**Examples:**
```bash
# Gmail for work
make-webapp "Work Gmail" "https://mail.google.com" --profile=Work

# Personal Notion
make-webapp "Notion" "https://notion.so"
```

### Theme Management
Switch between visual themes easily:
```bash
./scripts/switch-theme.sh <theme_name>
```

Themes control:
- Hyprland colors and borders
- Waybar styling
- Ghostty terminal colors
- Tofi launcher appearance
- Dunst notification styling
- Wallpaper

Available themes are in the `themes/` directory. To create a custom theme, copy an existing theme folder and modify the files.

### Deploying Changes
After editing dotfiles in the `stow/` directory:
```bash
./scripts/deploy-configs.sh
```

Or pull the latest changes and redeploy:
```bash
./update.sh
```

This will:
1. Pull latest changes from git
2. Restow all configuration files
3. Reload Hyprland if running

## 📂 Project Structure

```text
fedorarch/
├── bootstrap.sh          # Entry point
├── scripts/
│   ├── config/           # Configuration files (packages, repos)
│   ├── lib/              # Shared logic (installers, helpers)
│   ├── install-packages.sh
│   ├── setup-repos.sh
│   └── ...
├── stow/                 # Dotfiles (managed by GNU Stow)
│   ├── hyprland/
│   ├── waybar/
│   └── ...
└── tests/                # Validation and unit tests
```

## 🛡 Testing & Validation

Before applying changes, you can validate the configuration:
```bash
./validate-configs.sh
```

To test the installation logic without changing your system:
```bash
DRY_RUN=1 ./scripts/install-packages.sh
```

## ⌨ Key Bindings (Cheat Sheet)

| Key | Action |
| :--- | :--- |
| `Super + Space` | App Launcher (Tofi) |
| `Super + Return` | Terminal (Ghostty) |
| `Super + Q` | Close Window |
| `Super + F` | Fullscreen |
| `Super + G` | Lazygit |
| `Super + D` | Lazydocker |
| `Super + K` | Show Keybinds |
| `Super + Shift + S` | Screenshot (Area) |


## 💡 Tips & Tricks

### Performance Optimization
- **Check System Performance:** Run `system-monitor` to see resource usage
- **Free RAM:** Use `toggle-docker` to stop Docker containers when not needed
- **Waybar Widgets:** CPU, memory, and battery status update every 5 seconds

### Workflow Tips
1. **Use Workspaces:** Organize by task (1=Email, 2=Code, 3=Browser, etc.)
2. **Web Apps:** Create focused apps for frequent sites (Gmail, Slack, etc.)
3. **Clipboard History:** `Super + Shift + V` to access recent clipboard items
4. **Lazy*:** Use `Super + G` (Lazygit) and `Super + D` (Lazydocker) for visual management

### Customization
- **Keybinds:** Add custom binds in `~/.config/hypr/user.conf`
- **Startup Apps:** Add to `~/.config/hypr/autostart.conf`
- **Waybar:** Customize modules in `~/.config/waybar/config`
- **Monitor Rules:** Per-monitor workspace assignments in `~/.config/hypr/monitors.conf`

### Multi-Monitor Setup
When connecting/disconnecting monitors:
1. Run `hyprctl monitors` to see current setup
2. Update `~/.config/hypr/monitors.conf` if needed
3. Run `reset-workspaces.sh` to redistribute workspaces
4. Reload Hyprland: `hyprctl reload`

### Troubleshooting
**Problem:** Workspaces on wrong monitor  
**Solution:** Run `reset-workspaces.sh`

**Problem:** Wallpaper not showing  
**Solution:** Run `start-hyprpaper.sh`

**Problem:** Clipboard not working  
**Solution:** `systemctl --user restart cliphist`

**Problem:** Missing commands in PATH  
**Solution:** Log out and back in, or run `source ~/.zshrc`


## 🔧 Advanced Usage

### Dry Run Mode
Test changes without modifying your system:
```bash
DRY_RUN=1 ./scripts/install-packages.sh
```

### Adding Packages
Interactively add new packages to the configuration:
```bash
./scripts/add-package.sh
```

This will:
1. Install the package to verify it exists
2. Add it to the appropriate category in `scripts/config/packages.sh`
3. Make it part of future installations

### Custom Themes
Create your own theme:
```bash
cp -r themes/Default themes/MyTheme
# Edit files in themes/MyTheme/
./scripts/switch-theme.sh MyTheme
```

### Backup & Restore
Configurations are automatically backed up before deployment to:
```
~/.config.backup-YYYYMMDD-HHMMSS/
```

## 🤝 Contributing

We welcome contributions! Here's how:

1.  **Fork** the repository
2.  **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3.  **Test** your changes:
    ```bash
    ./validate-configs.sh
    DRY_RUN=1 ./bootstrap.sh  # Test in VM if possible
    ```
4.  **Commit** with clear messages (`git commit -m 'Add amazing feature'`)
5.  **Push** to your fork (`git push origin feature/amazing-feature`)
6.  **Open** a Pull Request

### Guidelines
- Follow existing code style (shellcheck-compliant bash)
- Test on a fresh Fedora install if possible
- Update documentation for new features
- Keep commits focused and atomic

## 📄 License

This project is open source. Feel free to use, modify, and distribute for non-commercial purposes.

## 🙏 Acknowledgments

- Inspired by [Omarchy](https://github.com/basecamp/omarchy)
- Thanks to all COPR repository maintainers

---

**Note:** This is a personal configuration shared publicly. Customize it to fit your needs!

