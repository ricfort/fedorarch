#!/usr/bin/env bash
# Helper script to set up a nice shell prompt with colors

# Add to ~/.bashrc if not already there
if [ -f ~/.bashrc ]; then
    # Check if we've already added our config
    if ! grep -q "# Fedorarch shell setup" ~/.bashrc; then
        cat >> ~/.bashrc << 'EOF'

# Fedorarch shell setup
# Enable colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Colorful prompt (Catppuccin Mocha colors)
export PS1='\[\033[38;2;138;173;244m\]\u\[\033[0m\]@\[\033[38;2;166;227;161m\]\h\[\033[0m\]:\[\033[38;2;137;180;250m\]\w\[\033[0m\]\$ '

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'
EOF
        echo "Shell setup added to ~/.bashrc"
        echo "Run: source ~/.bashrc to apply changes"
    else
        echo "Shell setup already in ~/.bashrc"
    fi
else
    echo "~/.bashrc not found, creating it..."
    cat > ~/.bashrc << 'EOF'
# Fedorarch shell setup
# Enable colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Colorful prompt (Catppuccin Mocha colors)
export PS1='\[\033[38;2;138;173;244m\]\u\[\033[0m\]@\[\033[38;2;166;227;161m\]\h\[\033[0m\]:\[\033[38;2;137;180;250m\]\w\[\033[0m\]\$ '

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'
EOF
    echo "Created ~/.bashrc with shell setup"
fi

