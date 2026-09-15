# The single package list: macOS, Homebrew. Read by the `packages` step.
# What is here, and what stays in your hands: docs/outils.md.

# --- formulas ---

# core: shell, multiplexer, vcs
brew "git"
brew "tmux"
brew "zsh"
brew "bash"
brew "bash-completion@2"

# modern CLI
brew "tree"
brew "eza"
brew "zoxide"
brew "fzf"
brew "bat"
brew "fd"
brew "ripgrep"
brew "btop"
brew "jq"
brew "lazygit"
# yazi and what its previews need: sevenzip (archives), poppler (PDF), resvg
# (SVG), ffmpeg (video), imagemagick (fonts, HEIC). Without them yazi runs,
# it just shows nothing for those types.
brew "yazi"
brew "ffmpeg"
brew "sevenzip"
brew "poppler"
brew "resvg"
brew "imagemagick"

# build & tasks
brew "make"
brew "cmake"
brew "just"

# prompt & runtimes
brew "starship"
brew "mise"

# infra / automation
brew "ansible"
brew "ansible-lint"
# The CLI only: on macOS podman needs a Linux VM, created once by hand with
# `podman machine init` (docs/outils.md). The cask below starts it at login.
brew "podman"

# network
brew "cloudflared"

# secrets / security -- no client here, see docs/outils.md
brew "age"
brew "sops"
brew "age-plugin-yubikey"
brew "ykman"
brew "openssh"
brew "libfido2"

# --- casks ---

# terminal & font
cask "ghostty"
cask "kitty"
cask "font-jetbrains-mono-nerd-font"

# dev GUI
cask "jetbrains-toolbox"
cask "gitkraken"
cask "docker-desktop"
# The counterpart of docker-desktop, not a duplicate: docker-desktop ships its
# own VM, daemon and CLI in one package, while `brew podman` is a bare CLI. This
# cask is what creates and starts podman's VM.
cask "podman-desktop"

# productivity
cask "raycast"
cask "keymapp"
cask "obsidian"

# AI
cask "claude"

# browsers
cask "firefox"
cask "google-chrome"
