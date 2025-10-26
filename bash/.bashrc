# ==========================================
# ~/.bashrc
# ==========================================

# Load common environment variables
[ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/env" ] && . "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/env"

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

# asdf version manager and completions
if [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
    . /opt/homebrew/opt/asdf/libexec/asdf.sh
fi
if [ -f /opt/homebrew/opt/asdf/etc/bash_completion.d/asdf.bash ]; then
    . /opt/homebrew/opt/asdf/etc/bash_completion.d/asdf.bash
fi

# Load common aliases
[ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/aliases" ] && . "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/aliases"

# Shell integrations
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
fi