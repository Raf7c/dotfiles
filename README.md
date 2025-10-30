# 🏠 dotfiles

Cross-platform configuration for modern development environments.

**Supported:** macOS · Fedora · Arch Linux

[📚 Complete Wiki](https://github.com/Raf7c/dotfiles/wiki)

---

---

## 📋 Table of Contents

- [Prerequisites](#-prerequisites)
- [Quick Installation](#-quick-installation)
- [Documentation](#-documentation)
- [What's Included](#-whats-included)
- [Updates](#-updates)

## 🔧 Prerequisites

### macOS
- **Version**: macOS 12.0 or higher
- **Architecture**: Apple Silicon (M1/M2/M3/M4) or Intel
- **Required tools**: git, curl (Xcode Command Line Tools)

### Fedora
- **Version**: Fedora 38 or higher
- **Required tools**: git, curl, dnf
- **Access**: sudo privileges

### Arch Linux
- **Version**: Latest rolling release
- **Required tools**: git, curl, pacman
- **Access**: sudo privileges

## 🚀 Quick Installation

```bash
# Clone the repository
git clone https://github.com/Raf7c/dotfiles.git ~/.dotfiles

# Launch installation
cd ~/.dotfiles
./bootstrap.sh
```

**What it does:**
- ✅ Detects your operating system automatically
- ✅ Verifies system requirements
- ✅ Creates symbolic links for all configurations
- ✅ Installs packages (Homebrew/DNF/Pacman)
- ✅ Configures Zsh, Tmux, Git, and OS-specific preferences
- ✅ Sets up performance optimizations

> **📝 Log:** `~/.dotfiles/install.log` | **⏱️ Duration:** 3-10 min | **🔄 Idempotent:** Safe to re-run

**Detailed guide:** [📦 Installation Wiki](https://github.com/Raf7c/dotfiles/wiki/Installation)

## 📚 Documentation

**[📖 Complete Wiki →](https://github.com/Raf7c/dotfiles/wiki)**

| 📄 Guide | 📝 Description |
|---------|---------------|
| [Installation](https://github.com/Raf7c/dotfiles/wiki/Installation) | Step-by-step setup guide |
| [Configuration](https://github.com/Raf7c/dotfiles/wiki/Configuration) | Architecture & structure |
| [Zsh Setup](https://github.com/Raf7c/dotfiles/wiki/Zsh-Configuration) | Shell, plugins, optimizations |
| [Tmux Setup](https://github.com/Raf7c/dotfiles/wiki/Tmux-Configuration) | Terminal multiplexer config |
| [Performance](https://github.com/Raf7c/dotfiles/wiki/Performance-Optimizations) | Speed optimizations & benchmarks |
| [Troubleshooting](https://github.com/Raf7c/dotfiles/wiki/Troubleshooting) | Common issues & solutions |
| [FAQ](https://github.com/Raf7c/dotfiles/wiki/FAQ) | Frequently asked questions |
| [Scripts Reference](https://github.com/Raf7c/dotfiles/wiki/Scripts-Reference) | Documentation of all scripts |

## 🛠️ What's Included

### Core Tools
- **Terminal:** [Ghostty](https://ghostty.org/) with [Catppuccin](https://github.com/catppuccin/catppuccin) theme
- **Shell:** [Zsh](https://www.zsh.org/) + [Zinit](https://github.com/zdharma-continuum/zinit) + [Starship](https://starship.rs/)
- **Multiplexer:** [Tmux](https://github.com/tmux/tmux) with TPM plugins
- **Editor:** [Vim](https://www.vim.org/) / [Neovim](https://neovim.io/) via [asdf](https://asdf-vm.com/)

### CLI Utilities
`bat` · `eza` · `fzf` · `ripgrep` · `fd` · `btop` · `zoxide` · `tree` · `starship` · `git` · `gcc` · `make`

### Features
- ✅ **Cross-platform** - macOS, Fedora, Arch Linux
- ✅ **XDG compliant** - Clean home directory
- ✅ **Performance optimized** - Shell startup <200ms
- ✅ **Modular scripts** - Easy to customize
- ✅ **POSIX sh** - Maximum portability
- ✅ **Comprehensive logging** - Full installation logs
- ✅ **Idempotent** - Safe to re-run anytime

**[📄 Package lists →](install/packages/)**

## ⚙️ Key Features

### 🚀 Performance
- **Shell startup:** <200ms on Apple Silicon
- **Async plugin loading** - Non-blocking Zsh plugins
- **Smart caching** - GCC aliases, completions
- **Optimized Tmux** - Reduced memory & CPU usage

### 🎨 Design
- **Catppuccin theme** - Mocha (dark) & Latte (light)
- **Nerd Fonts** - Monaspace, JetBrains Mono
- **Consistent colors** - Across terminal, Tmux, and editors

### 🔧 Developer Experience
- **XDG compliant** - Clean `$HOME` directory
- **Smart aliases** - `cd` → zoxide, `ls` → eza
- **Git shortcuts** - 20+ productivity aliases
- **Tmux prefix** - `Ctrl+Space` (more ergonomic)

**[📖 Detailed configuration →](https://github.com/Raf7c/dotfiles/wiki/Configuration)**

## 🔄 Updates

```bash
cd ~/.dotfiles
./update.sh
```

Updates Homebrew packages, Zsh plugins, Tmux plugins, and asdf.  
**Duration:** 30s - 5min

**[📖 Update guide →](https://github.com/Raf7c/dotfiles/wiki/Installation#updates)**

---

## 💻 Tested On

### macOS
- **Mac mini M1** (16GB) - macOS Sequoia 15.2
- **MacBook Pro M1 Max** (64GB) - macOS Sequoia 15.2
- **Compatibility:** Apple Silicon · Intel · macOS 12.0+

### Linux
- **Fedora 40** - Workstation Edition
- **Arch Linux** - Rolling Release (2024)
- **Compatibility:** x86_64 architecture

---

## 🐛 Need Help?

- **[🔧 Troubleshooting Guide](https://github.com/Raf7c/dotfiles/wiki/Troubleshooting)** - Common issues & solutions
- **[❓ FAQ](https://github.com/Raf7c/dotfiles/wiki/FAQ)** - Frequently asked questions
- **[📝 Issues](https://github.com/Raf7c/dotfiles/issues)** - Report bugs or request features

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

[Catppuccin](https://github.com/catppuccin/catppuccin) · [Zinit](https://github.com/zdharma-continuum/zinit) · [Starship](https://starship.rs/) · [Ghostty](https://ghostty.org/) · [Homebrew](https://brew.sh/)

---

<div align="center">

**[📚 Complete Documentation](https://github.com/Raf7c/dotfiles/wiki)** · **[🚀 Get Started](https://github.com/Raf7c/dotfiles/wiki/Installation)** · **[💬 Issues](https://github.com/Raf7c/dotfiles/issues)**

Built with ❤️ for macOS · Linux · Cross-platform environments ·

</div>
