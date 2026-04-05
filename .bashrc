[ -f "$HOME/.config/shell/env" ] && . "$HOME/.config/shell/env"

case $- in
  *i*) ;;
  *) return ;;
esac

[ -f "$HOME/.config/shell/alaiase" ] && . "$HOME/.config/shell/alaiase"

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash/history"
HISTSIZE=10000
HISTFILESIZE=10000
mkdir -p "$(dirname "$HISTFILE")"
shopt -s histappend
HISTCONTROL=ignorespace:erasedups
PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash --cmd cd)"
command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"
