# ==========================================
# ~/.zshrc
# Interactive shell configuration
# ==========================================

# Load environment variables first
source "${DOTFILES:-$HOME/.dotfiles}/.config/shell/env"

# History
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE="${XDG_STATE_HOME:-${HOME}/.local/state}/zsh/history"
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Homebrew completions (macOS only)
case "$OSTYPE" in
  darwin*)
    command -v brew >/dev/null 2>&1 && \
    [ -r "/opt/homebrew/share/zsh/site-functions/_brew" ] && \
    FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
    ;;
esac

# asdf version manager (cross-platform)
if [ -n "${ASDF_DATA_DIR:-}" ] && [ -f "${ASDF_DATA_DIR}/asdf.sh" ]; then
    . "${ASDF_DATA_DIR}/asdf.sh"
    fpath=(${ASDF_DIR}/completions $fpath)
elif [ -f "${HOME}/.asdf/asdf.sh" ]; then
    . "${HOME}/.asdf/asdf.sh"
    fpath=(${ASDF_DIR}/completions $fpath)
elif [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
    . /opt/homebrew/opt/asdf/libexec/asdf.sh
    fpath=(${ASDF_DIR}/completions $fpath)
elif [ -f /usr/local/opt/asdf/libexec/asdf.sh ]; then
    . /usr/local/opt/asdf/libexec/asdf.sh
    fpath=(${ASDF_DIR}/completions $fpath)
fi

# Load common aliases
[ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/aliases" ] && . "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/aliases"

# Load zinit if available
[ -f "${DOTFILES:-$HOME/.dotfiles}/zsh/zinit.zsh" ] && . "${DOTFILES:-$HOME/.dotfiles}/zsh/zinit.zsh"

# Shell integrations (centralized function)
load_integrations() {
    command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
    command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"
    # Initialize zoxide last to avoid conflicts
    if command -v zoxide >/dev/null 2>&1; then
        export _ZO_DOCTOR=0 2>/dev/null  # Suppress zoxide doctor message
        eval "$(zoxide init zsh)"
    fi
}
load_integrations
