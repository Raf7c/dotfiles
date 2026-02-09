# Bash
# 1. History
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash/history"
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend
HISTCONTROL=ignorespace:erasedups
# Share history between sessions
PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# 2. Env (PATH, Homebrew, asdf…)
[ -f "$HOME/.config/shell/env" ] && . "$HOME/.config/shell/env"

# 2b. asdf completions (Bash)
command -v asdf >/dev/null 2>&1 && . <(asdf completion bash)

# 3. Aliases
[ -f "$HOME/.config/shell/aliases" ] && . "$HOME/.config/shell/aliases"

# 4. zoxide (smarter cd) — --cmd cd replaces cd
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash --cmd cd)"

# 5. fzf — shortcuts (Ctrl-T files, Ctrl-R history, Alt-C cd) + fuzzy completion
command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"

# 6. Starship prompt
command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"
