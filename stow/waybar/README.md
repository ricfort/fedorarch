# Waybar Configuration

## Theme System

The waybar styles use CSS variables for easy theme swapping. All theme colors, spacing, and typography are defined at the top of `style.css` in the `:root` section.

### To Change Themes:

1. Open `~/.config/waybar/style.css`
2. Find the `:root` section at the top (lines 5-36)
3. Modify the CSS variables to your desired theme colors

### Example: Switching to a Blue Theme

```css
:root {
  --bg-primary: rgba(30, 30, 46, 0.95);
  --text-primary: #cad3f5;
  --text-accent: #8aadf4;
  --text-urgent: #f38ba8;
  --text-hover: #8aadf4;
  --border-primary: rgba(138, 173, 244, 0.2);
  /* ... etc */
}
```

### Available Variables:

- **Background**: `--bg-primary`, `--bg-secondary`
- **Text**: `--text-primary`, `--text-accent`, `--text-urgent`, `--text-hover`
- **Borders**: `--border-primary`, `--border-accent`
- **Shadow**: `--shadow`
- **Spacing**: `--spacing-xs` through `--spacing-xl`
- **Typography**: `--font-size`, `--font-weight-normal`, `--font-weight-bold`, `--letter-spacing-*`

After changing variables, restart waybar:
```bash
killall waybar; waybar &
```

