# ==========================================
# ~/.zshrc
# ==========================================

# History
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE="${XDG_DATA_HOME}/zsh/history"
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Homebrew completions (macOS only)
if [ "$(uname -s)" = "Darwin" ]; then
    command -v brew >/dev/null 2>&1 && \
    [ -r "/opt/homebrew/share/zsh/site-functions/_brew" ] && \
    FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
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

# Load zinit if available
[ -f "${DOTFILES:-$HOME/.dotfiles}/zsh/zinit.zsh" ] && . "${DOTFILES:-$HOME/.dotfiles}/zsh/zinit.zsh"

# Shell integrations
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
fi
