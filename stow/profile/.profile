# Fedorarch profile - sourced by display managers and desktop environments
# This ensures ~/.local/bin is in PATH for all applications

# Add ~/.local/bin to PATH if not already present
if [ -d "$HOME/.local/bin" ]; then
    case ":$PATH:" in
        *:"$HOME/.local/bin":*)
            ;;
        *)
            export PATH="$HOME/.local/bin:$PATH"
            ;;
    esac
fi

