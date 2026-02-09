# Zsh
# 1. History
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# 2. Env (PATH, Homebrew, asdf…)
[ -f "$HOME/.config/shell/env" ] && . "$HOME/.config/shell/env"

# 2b. asdf completions (Zsh) — create file if needed, then add to fpath
if command -v asdf >/dev/null 2>&1; then
  ASDF_COMP="${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
  [ ! -f "$ASDF_COMP/_asdf" ] && mkdir -p "$ASDF_COMP" && asdf completion zsh > "$ASDF_COMP/_asdf"
  [ -d "$ASDF_COMP" ] && fpath=("$ASDF_COMP" $fpath)
fi

# 3. Zinit + plugins
[ -f "$HOME/.config/zsh/zinit.zsh" ] && . "$HOME/.config/zsh/zinit.zsh"

# 4. Aliases
[ -f "$HOME/.config/shell/aliases" ] && . "$HOME/.config/shell/aliases"

# 5. zoxide (smarter cd) — after compinit; --cmd cd replaces cd
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"

# 6. fzf — shortcuts + fuzzy completion
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# 7. Starship prompt
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
