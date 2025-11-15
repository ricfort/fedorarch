# Hyprpaper Configuration

## Setting up your Samurai with Lotus Flowers Wallpaper

1. **Download or create your wallpaper:**
   - Find or create a samurai with lotus flowers wallpaper
   - Save it to `~/Pictures/Wallpapers/samurai-lotus.jpg` (or your preferred location)

2. **Update the config:**
   - Edit `~/.config/hyprpaper/hyprpaper.conf`
   - Update the wallpaper paths to point to your image file
   - Make sure the paths match your actual monitor names (check with `hyprctl monitors`)

3. **Apply the wallpaper:**
   - Restart hyprpaper: `killall hyprpaper; hyprpaper &`
   - Or reload Hyprland: `hyprctl reload`

## Example commands:

```bash
# Create wallpaper directory
mkdir -p ~/Pictures/Wallpapers

# Download a wallpaper (example - replace with your preferred source)
# wget -O ~/Pictures/Wallpapers/samurai-lotus.jpg <your-wallpaper-url>

# After stowing, update the config with your wallpaper path
# Then restart hyprpaper
killall hyprpaper; hyprpaper &
```

## Monitor names:

Check your monitor names with:
```bash
hyprctl monitors
```

Then update the wallpaper lines in the config to match your monitor names.

