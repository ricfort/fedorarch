# Fedorarch zsh setup

# Enable colors
export CLICOLOR=1

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Colorful prompt (Japanese Paper theme colors)
autoload -U colors && colors
PROMPT='%F{#d4a574}%n%f@%F{#9db5a0}%m%f:%F{#8b9db5}%~%f$ '

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'

# Show fastfetch on terminal open (only for interactive shells)
if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

