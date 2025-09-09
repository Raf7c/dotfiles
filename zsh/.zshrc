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

# Complétions (cache XDG)
autoload -Uz compinit
_compdump="${XDG_CACHE_HOME}/zsh/.zcompdump"
compinit -d "${_compdump}"# Charger les aliases communs

source ~/.dotfiles/.config/shell/aliases
[ -f "$DOTFILES/zsh/zinit.zsh" ] && . "$DOTFILES/zsh/zinit.zsh"
