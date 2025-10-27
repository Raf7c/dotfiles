# ==========================================
# ~/.bash_profile
# ==========================================

# Load environment variables
. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/env"

# Homebrew (Apple Silicon only)
case "$OSTYPE" in
  darwin*)
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"
        export HOMEBREW_NO_AUTO_UPDATE=1
        PATH="/opt/homebrew/opt/gcc/bin:/opt/homebrew/opt/llvm/bin:$PATH"
    fi
    ;;
esac

# Load interactive configuration
. "$HOME/.bashrc"
