# 🏠 dotfiles

Personal configuration for macOS development environment.

 [📚 Complete Wiki](../../wiki)

---

## ⚡ Quick Start

```bash
# Clone and install
git clone https://github.com/your-username/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

**Installation time:** 1-2 minutes | **Shell startup:** <200ms

---

## 📋 Table of Contents

- [Prerequisites](#-prerequisites)
- [Quick Installation](#-quick-installation)
- [Documentation](#-documentation)
- [What's Included](#-whats-included)
- [Updates](#-updates)

## 🔧 Prerequisites

- **Operating System**: macOS 15.0 or higher
- **Architecture**: Apple Silicon (M1/M2/M3/M4) or Intel
- **Access**: Administrator rights for installation
- **Required tools**: git, curl (installed via Xcode Command Line Tools)

## 🚀 Quick Installation

```bash
# Clone the repository
git clone https://github.com/your-username/.dotfiles.git ~/.dotfiles

# Launch installation
cd ~/.dotfiles
./bootstrap.sh
```

**What it does:**
- ✅ Verifies system requirements
- ✅ Creates symbolic links for all configurations
- ✅ Installs Homebrew + all packages
- ✅ Configures Zsh, Tmux, Git, and macOS preferences
- ✅ Sets up performance optimizations

> **📝 Log:** `~/.dotfiles/install.log` | **⏱️ Duration:** 1 min | **🔄 Idempotent:** Safe to re-run

**Detailed guide:** [📦 Installation Wiki](../../wiki/Installation)

## 📚 Documentation

**[📖 Complete Wiki →](../../wiki)**

| 📄 Guide | 📝 Description |
|---------|---------------|
| [Installation](../../wiki/Installation) | Step-by-step setup guide |
| [Configuration](../../wiki/Configuration) | Architecture & structure |
| [Zsh Setup](../../wiki/Zsh-Configuration) | Shell, plugins, optimizations |
| [Tmux Setup](../../wiki/Tmux-Configuration) | Terminal multiplexer config |
| [Performance](../../wiki/Performance-Optimizations) | Speed optimizations & benchmarks |
| [Troubleshooting](../../wiki/Troubleshooting) | Common issues & solutions |
| [FAQ](../../wiki/FAQ) | Frequently asked questions |
| [Scripts Reference](../../wiki/Scripts-Reference) | Documentation of all scripts |

## 🛠️ What's Included

### Core Tools
- **Terminal:** [Ghostty](https://ghostty.org/) with [Catppuccin](https://github.com/catppuccin/catppuccin) theme
- **Shell:** [Zsh](https://www.zsh.org/) + [Zinit](https://github.com/zdharma-continuum/zinit) + [Starship](https://starship.rs/)
- **Multiplexer:** [Tmux](https://github.com/tmux/tmux) with TPM plugins
- **Editor:** [Neovim](https://neovim.io/) via [asdf](https://asdf-vm.com/)

### CLI Utilities
`bat` · `fzf` · `ripgrep` · `fd` · `eza` · `zoxide` · `tree` · `git` · `gcc`

### Features
- ✅ **XDG compliant** - Clean home directory
- ✅ **Performance optimized** - Shell startup <200ms
- ✅ **Modular scripts** - Easy to customize
- ✅ **Comprehensive logging** - Full installation logs
- ✅ **Idempotent** - Safe to re-run anytime

**[📄 Full software list →](Brewfile)**

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

**[📖 Detailed configuration →](../../wiki/Configuration)**

## 🔄 Updates

```bash
cd ~/.dotfiles
./update.sh
```

Updates Homebrew packages, Zsh plugins, Tmux plugins, and asdf.  
**Duration:** 30s - 5min

**[📖 Update guide →](../../wiki/Installation#updates)**

---

## 💻 Tested On

- **Mac mini M1** (16GB) - macOS Sequoia 15.2
- **MacBook Pro M1 Max** (64GB) - macOS Sequoia 15.2

**Compatibility:** Apple Silicon · Intel Macs · macOS 12.0+

---

## 🐛 Need Help?

- **[🔧 Troubleshooting Guide](../../wiki/Troubleshooting)** - Common issues & solutions
- **[❓ FAQ](../../wiki/FAQ)** - Frequently asked questions
- **[📝 Issues](../../issues)** - Report bugs or request features

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

[Catppuccin](https://github.com/catppuccin/catppuccin) · [Zinit](https://github.com/zdharma-continuum/zinit) · [Starship](https://starship.rs/) · [Ghostty](https://ghostty.org/) · [Homebrew](https://brew.sh/)

---

<div align="center">

**[📚 Complete Documentation](../../wiki)** · **[🚀 Get Started](../../wiki/Installation)** · **[💬 Issues](../../issues)**

Built with ❤️ for macOS ·

</div>
