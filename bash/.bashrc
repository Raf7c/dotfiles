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
HISTCONTROL=ignoreboth

# Completions (macOS: Homebrew, Linux: system)
if [ "$(uname -s)" = "Darwin" ]; then
  [ -r /opt/homebrew/etc/profile.d/bash_completion.sh ] && . /opt/homebrew/etc/profile.d/bash_completion.sh
else
  [ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
fi

# Load common aliases
. ~/.dotfiles/.config/shell/aliases

