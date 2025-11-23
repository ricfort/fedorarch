#!/usr/bin/env bash
# LazyGit launcher that finds the current git repository
# Tries to find git repo from active window's working directory or falls back to home

# Function to find nearest git repository
find_git_repo() {
    local start_dir="$1"
    local current_dir="$start_dir"
    
    while [ "$current_dir" != "/" ]; do
        if [ -d "$current_dir/.git" ]; then
            echo "$current_dir"
            return 0
        fi
        current_dir=$(dirname "$current_dir")
    done
    return 1
}

# Try to get the active window's working directory using hyprctl
ACTIVE_PID=$(hyprctl activewindow -j 2>/dev/null | jq -r '.pid' 2>/dev/null || \
             hyprctl activewindow -j 2>/dev/null | grep -o '"pid":[0-9]*' | cut -d: -f2 | head -1)

if [ -n "$ACTIVE_PID" ] && [ "$ACTIVE_PID" != "null" ] && [ "$ACTIVE_PID" != "0" ]; then
    # Get the working directory of the active process
    if [ -r "/proc/$ACTIVE_PID/cwd" ]; then
        ACTIVE_CWD=$(readlink -f "/proc/$ACTIVE_PID/cwd" 2>/dev/null || echo "")
        
        if [ -n "$ACTIVE_CWD" ] && [ -d "$ACTIVE_CWD" ]; then
            GIT_REPO=$(find_git_repo "$ACTIVE_CWD")
            if [ -n "$GIT_REPO" ]; then
                cd "$GIT_REPO" && exec alacritty --class lazygit -e lazygit
                exit 0
            fi
        fi
    fi
fi

# Fallback: try common git repository locations
for dir in "$HOME" "$HOME/projects" "$HOME/code" "$HOME/dev" "$HOME/workspace"; do
    if [ -d "$dir" ]; then
        GIT_REPO=$(find_git_repo "$dir")
        if [ -n "$GIT_REPO" ]; then
            cd "$GIT_REPO" && exec alacritty --class lazygit -e lazygit
            exit 0
        fi
    fi
done

# Last resort: open lazygit in home directory and let it prompt for repo
cd "$HOME" && exec alacritty --class lazygit -e lazygit

