# ==========================================
# ~/.zprofile
# Login shell configuration (zprofile)
# ==========================================

# Homebrew (Apple Silicon only)
case "$OSTYPE" in
  darwin*)
    # Initialize Homebrew (Apple Silicon only)
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    # Homebrew configuration
    export HOMEBREW_NO_AUTO_UPDATE=1
    export PATH="$HOME/.dotfiles/bin:$PATH"
    # Add specific tool paths (Apple Silicon only)
    PATH="/opt/homebrew/opt/gcc/bin:/opt/homebrew/opt/llvm/bin:$PATH"
    export PATH
    ;;
esac