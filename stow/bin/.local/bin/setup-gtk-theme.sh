#!/usr/bin/env bash
# Setup GTK dark theme for file manager and GTK applications

# Set GNOME/GTK color scheme to dark
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true

# Set GTK theme to dark
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true

# Also set for GTK4
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true

# Create GTK config files for GTK2/GTK3 applications
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-application-prefer-dark-theme=1
EOF

mkdir -p ~/.config/gtk-4.0
cat > ~/.config/gtk-4.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-application-prefer-dark-theme=1
EOF

echo "GTK dark theme configured"
echo "  - GNOME color scheme: prefer-dark"
echo "  - GTK theme: Adwaita-dark"
echo "  - GTK config files created in ~/.config/gtk-*/"

