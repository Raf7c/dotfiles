# ==========================================
# ~/.zprofile
# Login shell configuration (zprofile)
# ==========================================

# Homebrew (Apple Silicon only)
if [ "$(uname -s)" = "Darwin" ]; then
    # Initialize Homebrew (Apple Silicon only)
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    # Homebrew configuration
    export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"
    export HOMEBREW_NO_AUTO_UPDATE=1
    
    # Add specific tool paths (Apple Silicon only)
    PATH="/opt/homebrew/opt/gcc/bin:/opt/homebrew/opt/llvm/bin:$PATH"
    export PATH
fi