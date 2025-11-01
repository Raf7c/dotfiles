#!/bin/sh
# ==========================================
# ~/test.sh
# Validate dotfiles installation
# ==========================================

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/src/lib/utils.sh"

echo "========================================="
echo "🧪 Testing dotfiles installation"
echo "========================================="
echo ""

# Detect OS
OS=$(detect_os)
echo "🖥️  System: $OS"
echo ""

FAILED=0

# Test essential commands
echo "📋 Essential commands..."
for cmd in git curl tmux gcc make; do
    if command -v "$cmd" >/dev/null 2>&1; then
        print_success "$cmd: $(command -v "$cmd")"
    else
        print_error "$cmd: NOT FOUND"
        FAILED=1
    fi
done

# Test modern CLI tools
echo "⚡ Modern CLI tools..."
for cmd in bat eza fzf rg fd btop tree zoxide starship; do
    if command -v "$cmd" >/dev/null 2>&1; then
        print_success "$cmd: $(command -v "$cmd")"
    else
        print_warning "$cmd: NOT FOUND (optional)"
    fi
done
echo ""

# Test package manager
echo "📦 Package manager..."
case "$OS" in
    macos)
        if command -v brew >/dev/null 2>&1; then
            print_success "Homebrew: $(brew --version | head -n1)"
        else
            print_error "Homebrew: NOT FOUND"
            FAILED=1
        fi
        ;;
    arch)
        if command -v pacman >/dev/null 2>&1; then
            print_success "Pacman: $(pacman --version | head -n1)"
        else
            print_error "Pacman: NOT FOUND"
            FAILED=1
        fi
        ;;
esac
echo ""

# Test ASDF
echo "📦 Version manager..."
if command -v asdf >/dev/null 2>&1; then
    print_success "asdf: $(command -v asdf)"
    echo "   Plugins: $(asdf plugin list | tr '\n' ' ')"
else
    print_warning "asdf: NOT FOUND (optional)"
fi
echo ""

# Test symlinks
echo "🔗 Symbolic links..."
for link in "$HOME/.zshrc" "$HOME/.config/git" "$HOME/.tool-versions"; do
    if [ -L "$link" ] && [ -e "$link" ]; then
        print_success "$(basename "$link"): OK"
    else
        print_error "$(basename "$link"): BROKEN or MISSING"
        FAILED=1
    fi
done
echo ""

# Test environment variables
echo "🐚 Environment variables..."
if [ -n "${XDG_CONFIG_HOME:-}" ]; then
    print_success "XDG_CONFIG_HOME: $XDG_CONFIG_HOME"
else
    print_warning "XDG_CONFIG_HOME: NOT SET"
fi

if [ -n "${DOTFILES:-}" ]; then
    print_success "DOTFILES: $DOTFILES"
else
    print_warning "DOTFILES: NOT SET"
fi

if [ -n "${OS_TYPE:-}" ]; then
    print_success "OS_TYPE: $OS_TYPE"
else
    print_warning "OS_TYPE: NOT SET"
fi
echo ""

# Summary
echo "========================================="
echo "📊 Test Summary"
echo "========================================="
if [ $FAILED -eq 0 ]; then
    print_success "✅ All critical checks passed!"
    print_info "Run 'source ~/.zshrc' if variables are not set"
    exit 0
else
    print_error "❌ Some critical checks failed!"
    print_info "Run ./bootstrap.sh to fix issues"
    exit 1
fi
