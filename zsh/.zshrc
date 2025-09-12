# ==========================================
# ~/.zshrc
# ==========================================

# History
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE="${XDG_DATA_HOME}/zsh/history"
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Completions (XDG cache)
autoload -Uz compinit
_compdump="${XDG_CACHE_HOME}/zsh/.zcompdump"
compinit -d "${_compdump}"

# Homebrew completions (macOS only)
[ "$(uname -s)" = "Darwin" ] && command -v brew >/dev/null 2>&1 && [ -r "$(brew --prefix)/share/zsh/site-functions/_brew" ] && FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"


# Load common aliases
source ~/.dotfiles/.config/shell/aliases

# Load zinit if available
[ -f "$DOTFILES/zsh/zinit.zsh" ] && . "$DOTFILES/zsh/zinit.zsh"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(starship init zsh)"