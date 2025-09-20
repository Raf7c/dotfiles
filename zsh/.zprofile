# ==========================================
# ~/.zprofile
# Login shell configuration (global env)
# ==========================================

# Homebrew (macOS only)
[ "$(uname -s)" = "Darwin" ] && (command -v brew >/dev/null 2>&1 && eval "$(brew shellenv)" || [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)")

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
command -v brew >/dev/null 2>&1 && export PATH="/opt/homebrew/opt/gcc/bin:$PATH"
command -v brew >/dev/null 2>&1 && export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# Homebrew bundle file
export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"
