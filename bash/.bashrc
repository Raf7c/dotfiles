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

# asdf version manager (cross-platform)
if [ -n "${ASDF_DATA_DIR:-}" ] && [ -f "${ASDF_DATA_DIR}/asdf.sh" ]; then
    . "${ASDF_DATA_DIR}/asdf.sh"
    [ -f "${ASDF_DIR}/etc/bash_completion.d/asdf.bash" ] && . "${ASDF_DIR}/etc/bash_completion.d/asdf.bash"
elif [ -f "${HOME}/.asdf/asdf.sh" ]; then
    . "${HOME}/.asdf/asdf.sh"
    [ -f "${HOME}/.asdf/etc/bash_completion.d/asdf.bash" ] && . "${HOME}/.asdf/etc/bash_completion.d/asdf.bash"
elif command -v brew >/dev/null 2>&1; then
    ASDF_PATH=$(brew --prefix asdf 2>/dev/null || echo "")
    if [ -n "$ASDF_PATH" ] && [ -f "${ASDF_PATH}/libexec/asdf.sh" ]; then
        . "${ASDF_PATH}/libexec/asdf.sh"
        [ -f "${ASDF_PATH}/etc/bash_completion.d/asdf.bash" ] && . "${ASDF_PATH}/etc/bash_completion.d/asdf.bash"
    fi
fi

# Load common aliases
[ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/aliases" ] && . "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/aliases"

# Shell integrations (centralized function)
load_integrations() {
    command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"
    command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"
    # Initialize zoxide last to avoid conflicts
    if command -v zoxide >/dev/null 2>&1; then
        export _ZO_DOCTOR=0 2>/dev/null  # Suppress zoxide doctor message
        eval "$(zoxide init bash --cmd cd)"
    fi
}
load_integrations
