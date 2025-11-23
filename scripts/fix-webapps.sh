#!/usr/bin/env bash
set -euo pipefail

# This script regenerates existing webapp desktop files to use direct chromium-browser command
# instead of the deprecated chromium-launcher.sh

echo "Updating webapps..."

WEBAPPS_DIR="$HOME/.local/share/applications"

# Find all desktop files containing chromium-launcher.sh
grep -l "chromium-launcher.sh" "$WEBAPPS_DIR"/*.desktop 2>/dev/null | while read -r file; do
    echo "Updating $file..."
    
    # Read the file content
    content=$(cat "$file")
    
    # Extract parameters
    profile=$(echo "$content" | grep -oP 'profile=\K[^ ]+')
    app=$(echo "$content" | grep -oP 'app=\K[^ ]+')
    class=$(echo "$content" | grep -oP 'class=\K[^ ]+')
    
    # Clean up extracted values (remove trailing characters if grep grabbed too much)
    profile=$(echo "$profile" | sed 's/[[:space:]]*$//')
    app=$(echo "$app" | sed 's/[[:space:]]*$//')
    class=$(echo "$class" | sed 's/[[:space:]]*$//')
    
    # Fallback defaults if extraction fails
    profile=${profile:-Default}
    
    # Replace Exec line
    if [ -n "$app" ]; then
        sed -i "s|Exec=.*chromium-launcher.sh.*|Exec=chromium-browser --profile-directory=$profile --app=$app --class=$class|" "$file"
    else
        # Standard browser launcher fallback
        sed -i "s|Exec=.*chromium-launcher.sh.*|Exec=chromium-browser --profile-directory=$profile|" "$file"
    fi
done

# Force update database
update-desktop-database ~/.local/share/applications/ 2>/dev/null || true

echo "Webapps updated successfully."













