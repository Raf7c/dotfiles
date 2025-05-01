#!/bin/zsh

### ----  PATH & ENVIRONMENT  ---- ###
# Définition initiale du PATH avec les priorités
export PATH="/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:$HOME/.asdf/shims:/opt/homebrew/bin:$PATH"

# Variables d'environnement générales
export TERM="xterm-256color"
export EDITOR=nvim
export HOMEBREW_BUNDLE_NO_LOCK=1
export HOMEBREW_CASK_OPTS="--no-quarantine"
export TERMINAL="kitty"
export BROWSER="arc"
export NULLCMD=bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Variables pour les outils de développement
export NVIM_CONFIG="$HOME/.config/nvim/init.lua"
export ASDF_CRATE_DEFAULT_PACKAGES_FILE="$ASDF_DEFAULTS_ROOT/.default-cargo-crates"

### ----  HISTORY  ---- ###
HISTSIZE=10000
HISTFILE="$HOME/.local/share/zsh/history"
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
setopt hist_find_no_dups
setopt hist_save_no_dups
setopt appendhistory

### ----  ALIASES  ---- ###
# Commandes générales
alias vim="nvim"
alias cat="bat"
alias cl="clear"
alias sczshrc="source ~/.zshrc"

# Navigation et listing
alias ls="eza -lhF --icons --git"
alias ll="eza -lahF --icons --git"
alias lt="eza -hF --tree --level=2 --long --icons --git"
alias ltree="eza -lahF --tree --level=2 --long --icons --git"

# Git
alias gs="git status"
alias gc="git commit"
alias gck="git checkout"
alias gb="git branch"

### ----  TOOLS INTEGRATION  ---- ###
# Intégration Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Intégration asdf
if [ -f "$HOME/.nix-profile/share/asdf-vm/asdf.sh" ]; then
  . "$HOME/.nix-profile/share/asdf-vm/asdf.sh"
elif [ -f "$HOME/.asdf/asdf.sh" ]; then
  . "$HOME/.asdf/asdf.sh"
fi

# Intégration pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

### ----  PLUGINS & EXTENSIONS  ---- ###
# Installation et chargement de zinit
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Chargement des plugins zinit
zinit load zsh-users/zsh-autosuggestions
zinit load zsh-users/zsh-syntax-highlighting
zinit load zsh-users/zsh-completions
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# Configuration des plugins
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -lah --color=always --icons --git $realpath'

### ----  PROMPT  ---- ###
# Initialisation de Starship
eval "$(starship init zsh)"