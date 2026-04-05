HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

[ -f "$HOME/.config/shell/env" ] && . "$HOME/.config/shell/env"
[ -f "$HOME/.config/shell/alaiase" ] && . "$HOME/.config/shell/alaiase"

if command -v asdf >/dev/null 2>&1; then
  ASDF_COMP="${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
  [ ! -f "$ASDF_COMP/_asdf" ] && mkdir -p "$ASDF_COMP" && asdf completion zsh > "$ASDF_COMP/_asdf"
  [ -d "$ASDF_COMP" ] && fpath=("$ASDF_COMP" $fpath)
fi

[ -f "$HOME/.config/zsh/zinit.zsh" ] && . "$HOME/.config/zsh/zinit.zsh"

: ${XDG_CACHE_HOME:=$HOME/.cache}
mkdir -p "$XDG_CACHE_HOME/zsh"
autoload -Uz compinit
compinit -C -d "$XDG_CACHE_HOME/zsh/.zcompdump"

(( ${+functions[zinit_completion_register]} )) && zinit_completion_register

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

if command -v eza >/dev/null 2>&1; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath 2>/dev/null'
  if command -v zoxide >/dev/null 2>&1; then
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons $realpath 2>/dev/null'
  fi
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath 2>/dev/null'
fi

command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"