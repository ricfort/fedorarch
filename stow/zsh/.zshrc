# Fedorarch zsh setup

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Zsh plugin manager (zgenom)
# https://github.com/jandamm/zgenom
if [[ ! -f "$HOME/.zgenom/zgenom.zsh" ]]; then
    git clone https://github.com/jandamm/zgenom.git "$HOME/.zgenom"
fi
source "$HOME/.zgenom/zgenom.zsh"

# Load plugins if the file doesn't exist yet
if ! zgenom saved; then
    # Plugins
    zgenom load zsh-users/zsh-completions
    zgenom load zsh-users/zsh-autosuggestions
    zgenom load zsh-users/zsh-syntax-highlighting

    # Prompt
    zgenom load starship/starship

    zgenom save
fi

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Aliases
alias ls='eza --icons --git'
alias ll='eza -lah --icons --git'
alias grep='rg'
alias cd='z'

# Initialize zoxide
eval "$(zoxide init zsh)"

# Initialize Starship prompt
eval "$(starship init zsh)"

# Show fastfetch on terminal open (only for interactive shells)
if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi
