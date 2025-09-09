# ==========================================
# ~/.bashrc
# ==========================================

# History
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE
HISTFILE="${XDG_DATA_HOME}/bash/history"
shopt -s histappend
HISTCONTROL=ignoreboth

# Completions (no cache like zsh/compinit)
if [ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
  . /opt/homebrew/etc/profile.d/bash_completion.sh
elif [ -r /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

# Load common aliases
. ~/.dotfiles/.config/shell/aliases

