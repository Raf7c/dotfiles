# ==========================================
# ~/.zprofile
# Login shell configuration (zprofile)
# ==========================================

# Homebrew (macOS only)
[ "$(uname -s)" = "Darwin" ] && (command -v brew >/dev/null 2>&1 && eval "$(brew shellenv)" || [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)")

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Homebrew bundle file
export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"


if command -v brew >/dev/null 2>&1; then
    PATH="/opt/homebrew/bin:$PATH"
    export HOMEBREW_NO_AUTO_UPDATE=1
    PATH="/opt/homebrew/opt/gcc/bin:$PATH"
    PATH="/opt/homebrew/opt/llvm/bin:$PATH"
    export PATH
fi