# ==========================================
# ~/.bashrc
# Interactive shell configuration
# ==========================================

# Load environment variables first
. "${DOTFILES:-$HOME/.dotfiles}/.config/shell/env"

# History
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE
HISTFILE="${XDG_STATE_HOME:-${HOME}/.local/state}/bash/history"
shopt -s histappend
HISTCONTROL=ignoreboth:erasedups

# Homebrew completions (macOS only)
case "$OSTYPE" in
  darwin*)
    if command -v brew >/dev/null 2>&1; then
        if [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
            . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
        fi
    fi
    ;;
esac








# asdf version manager
if [ -d "$HOME/.asdf" ]; then
    export PATH="$HOME/.asdf/shims:$PATH"
    [ -f "$HOME/.asdf/completions/asdf.bash" ] && . "$HOME/.asdf/completions/asdf.bash"
fi

# Load common aliases
[ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/aliases" ] && . "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/aliases"

# Shell integrations (centralized function)
load_integrations() {
    command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"
    command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"
    # Initialize zoxide last to avoid conflicts
    if command -v zoxide >/dev/null 2>&1; then
        eval "$(zoxide init bash --cmd cd)"
    fi
}
load_integrations
