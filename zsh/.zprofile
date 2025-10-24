# ==========================================
# ~/.zprofile
# Login shell configuration (zprofile)
# ==========================================

# Homebrew (macOS only)
if [ "$(uname -s)" = "Darwin" ]; then
    # Initialize Homebrew
    if command -v brew >/dev/null 2>&1; then
        eval "$(brew shellenv)"
    elif [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    # Homebrew configuration
    export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"
    export HOMEBREW_NO_AUTO_UPDATE=1
    
    # Add specific tool paths (only if brew is available)
    if command -v brew >/dev/null 2>&1; then
        BREW_PREFIX=$(brew --prefix)
        PATH="$BREW_PREFIX/opt/gcc/bin:$BREW_PREFIX/opt/llvm/bin:$PATH"
        export PATH
    fi
fi