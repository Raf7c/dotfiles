# ==========================================
# ~/.bashrc
# ==========================================

# Load common environment variables
[ -f "${DOTFILES:-$HOME/.dotfiles}/.config/shell/env" ] && . "${DOTFILES:-$HOME/.dotfiles}/.config/shell/env"

# History
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE
HISTFILE="${XDG_DATA_HOME}/bash/history"
shopt -s histappend
HISTCONTROL=ignoreboth:erasedups

# Completions (Apple Silicon)
if [ "$(uname -s)" = "Darwin" ]; then
  if [ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
    . /opt/homebrew/etc/profile.d/bash_completion.sh
  fi
fi

# Load common aliases
[ -f "${DOTFILES:-$HOME/.dotfiles}/.config/shell/aliases" ] && . "${DOTFILES:-$HOME/.dotfiles}/.config/shell/aliases"

# Shell integrations
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
if command -v fzf >/dev/null 2>&1; then
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
fi